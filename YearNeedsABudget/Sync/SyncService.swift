//
//  SyncProgressService.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 3/8/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation
import os.log

struct SyncService {
    
    //MARK: - TODO
    //Need to add code to clear out this folder in case I change the schema between uprades.
    
    //MARK: - Public
    static func getYearlySyncSummary(for year: Int = YnabCalendar.currentYear) -> YearlySyncSummary? {
        do {
            let json = try Data(contentsOf: getFileUrl(year))
            let syncSummary = try JSONDecoder().decode(YearlySyncSummary.self, from: json)
            os_log("Fetched sync status file for %{PUBLIC}@", log: .filesystem, type: .info, "\(year)")
            return syncSummary
        } catch {
            os_log("Failed to fetch sync progress year for %{PUBLIC}@: %{PUBLIC}@", log: .filesystem, type: .error, "\(year)", error.localizedDescription)
            return nil
        }
    }
    
    static func saveYearlySyncSummary(_ syncYear: YearlySyncSummary) {
        do {
            let jsonData = try JSONEncoder().encode(syncYear)
            try jsonData.write(to: getFileUrl(syncYear.year), options: [.completeFileProtection, .atomic])
            os_log("Saved sync status file for %{PUBLIC}@", log: .filesystem, type: .info, "\(syncYear.year)")
        } catch {
            os_log("Failed to save sync status file: %{PUBLIC}@", log: .filesystem, type: .error, error.localizedDescription)
        }
    }
    
    static func updateSyncProgressFile(year: Int = YnabCalendar.currentYear, fullReset: Bool = false) {
        guard let yearlySyncSummary = getYearlySyncSummary(for: year), !fullReset else {
            createNewSyncProgressFile()
            return
        }
        
        let monthlySummaries = Array(1...YnabCalendar.monthCount(for: year)).map { (month) -> MonthlySyncReport in
            if let existingSummary = yearlySyncSummary.monthlyReports.first(where: { $0.month == month }) {
                let updatedSyncStatus = getUpdatedSyncStatus(for: existingSummary)
                let lastSync = existingSummary.lastSyncTime
                return MonthlySyncReport(month, status: updatedSyncStatus, lastSyncTime: lastSync)
            }
            return MonthlySyncReport(month)
        }
        
        saveYearlySyncSummary(YearlySyncSummary(year, monthlyStatuses: monthlySummaries))
    }
    
    static func getUpdatedSyncStatus(for monthlySyncReport: MonthlySyncReport) -> SyncStatus {
       if monthlySyncReport.status == .upToDate {
          return isStillUpToDate(monthlySyncReport) ? .upToDate : .outOfDate
       }
        return monthlySyncReport.status
    }
    
    //MARK: - Private

    private static func getFileUrl(_ year: Int = YnabCalendar.currentYear) -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("sync_progress_\(year).json")
    }
    
    private static func createNewSyncProgressFile() {
        var syncMonths: [MonthlySyncReport] = []
        for month in 1...YnabCalendar.currentMonth {
            let monthStatus = MonthlySyncReport(month, lastSyncTime: nil)
            syncMonths.append(monthStatus)
        }
        let yearlySummary = YearlySyncSummary(YnabCalendar.currentYear, monthlyStatuses: syncMonths)
        os_log("Initiating new sync status file for %{PUBLIC}@", log: .filesystem, type: .info, "\(yearlySummary.year)")
        saveYearlySyncSummary(yearlySummary)
    }
    
    private static let tenMinutes: TimeInterval = 60 * 10
    private static let oneDay: TimeInterval = 60 * 60 * 24
    private static let oneWeek: TimeInterval = 60 * 60 * 24 * 7
    
    private static func isStillUpToDate(_ syncMonth: MonthlySyncReport) -> Bool {
        guard let lastSync = syncMonth.lastSyncTime, syncMonth.status == .upToDate else { return false }
        let monthsAgo = YnabCalendar.currentMonth - syncMonth.month
        
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
