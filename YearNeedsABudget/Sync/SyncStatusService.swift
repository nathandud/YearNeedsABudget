//
//  SyncProgressService.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 3/8/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation
import os.log

struct SyncStatusService {
    
    //MARK: - Public
    static func fetchYearlySyncSummary(for year: Int = currentYear) -> YearlySyncSummary? {
        do {
            let json = try Data(contentsOf: getFileUrl(year))
            let syncProgress = try JSONDecoder().decode([YearlySyncSummary].self, from: json)
            return syncProgress.first { $0.year == year }
        } catch {
            os_log("Failed to fetch sync progress year for %{PUBLIC}@: %{PUBLIC}@", log: .repository, type: .error, "\(year)", error.localizedDescription)
            return nil
        }
    }
    
    static func saveYearlySyncSummary(_ syncYear: YearlySyncSummary) {
        do {
            let jsonData = try JSONEncoder().encode(syncYear)
            try jsonData.write(to: getFileUrl(syncYear.year), options: [.completeFileProtection, .atomic])
        } catch {
            os_log("Failed to save sync status file: %{PUBLIC}@", log: .repository, type: .error, error.localizedDescription)
        }
    }
    
    static func updateSyncProgressFile(year: Int = currentYear, fullReset: Bool = false) {
        guard let currentSyncStatus = fetchYearlySyncSummary(for: year), !fullReset else {
            createNewSyncProgressFile()
            return
        }
        
        var monthlyStatuses: [MonthSyncStatus] = []
        let monthCount = year == currentYear ? Calendar.current.component(.month, from: Date()) : 12
        
        for month in 1...monthCount {
            guard let syncMonth = currentSyncStatus.monthlyStatuses.first(where: { $0.month == month }), isUpToDate(syncMonth: syncMonth) else {
                monthlyStatuses.append(MonthSyncStatus(month))
                return
            }
            monthlyStatuses.append(syncMonth)
        }
        
        saveYearlySyncSummary(YearlySyncSummary(year, monthlyStatuses: monthlyStatuses))
    }
    
    //MARK: - Private
    private static let currentYear = Calendar.current.component(.year, from: Date())
    private static let currentMonth = Calendar.current.component(.month, from: Date())

    private static func getFileUrl(_ year: Int = currentYear) -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("sync_progress_\(year).json")
    }
    
    private static func fileExists(for year: Int = currentYear) -> Bool {
        do {
            let _ = try Data(contentsOf: getFileUrl(year))
            return true
        } catch {
            return false
        }
    }
    
    private static func createNewSyncProgressFile() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        var syncMonths: [MonthSyncStatus] = []
        
        for month in 1...currentMonth {
            let monthStatus = MonthSyncStatus(month)
            syncMonths.append(monthStatus)
        }
        let yearlySummary = YearlySyncSummary(currentYear, monthlyStatuses: syncMonths)
        saveYearlySyncSummary(yearlySummary)
        
        if fileExists() { os_log("Successfully initiated new sync status file for %{PUBLIC}@", log: .repository, type: .info, "\(yearlySummary.year)") }
    }
    
    private static let tenMinutes: TimeInterval = 60 * 10
    private static let oneDay: TimeInterval = 60 * 60 * 24
    private static let oneWeek: TimeInterval = 60 * 60 * 24 * 7
    
    private static func isUpToDate(syncMonth: MonthSyncStatus) -> Bool {
        guard let lastSync = syncMonth.lastSyncTime else { return false }
        let monthsAgo = currentMonth - syncMonth.month
        
        switch monthsAgo {
        case 0:
            return Calendar.current.compare(Date().addingTimeInterval(tenMinutes), to: lastSync, toGranularity: .minute) == .orderedAscending
        case 1:
            return Calendar.current.compare(Date().addingTimeInterval(oneDay), to: lastSync, toGranularity: .minute) == .orderedAscending
        case 2:
            return Calendar.current.compare(Date().addingTimeInterval(oneDay * 3), to: lastSync, toGranularity: .minute) == .orderedAscending
        default:
            return Calendar.current.compare(Date().addingTimeInterval(oneWeek), to: lastSync, toGranularity: .minute) == .orderedAscending
        }
    }
}
