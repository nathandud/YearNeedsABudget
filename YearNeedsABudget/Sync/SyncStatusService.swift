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
    
    private static let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("sync_progress.json")
    
    static func fetchSyncProgress(for year: Int) -> YearSyncStatus? {
        do {
            let json = try Data(contentsOf: fileUrl)
            let syncProgress = try JSONDecoder().decode([YearSyncStatus].self, from: json)
            return syncProgress.first { $0.year == year }
        } catch {
            os_log("Failed to fetch sync progress year %{PUBLIC}@: %{PUBLIC}@", log: .repository, type: .error, "\(year)", error.localizedDescription)
            return nil
        }
    }
    
    static func saveSyncProgress(syncYear: YearSyncStatus) {
        do {
            let jsonData = try JSONEncoder().encode(syncYear)
            try jsonData.write(to: fileUrl, options: [.completeFileProtection, .atomic])
        } catch {
            os_log("Failed to save sync status file: %{PUBLIC}@", log: .repository, type: .error, error.localizedDescription)
        }
    }
    
    static func initializeSyncProgressFile() {
        if !fileExists() {
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            var syncMonths: [MonthSyncStatus] = []
            
            for month in 1...currentMonth {
                let monthSyncProgress = MonthSyncStatus(month: month)
                syncMonths.append(monthSyncProgress)
            }
            let yearSyncProgress = YearSyncStatus(year: currentYear, syncProgressMonths: syncMonths)
            saveSyncProgress(syncYear: yearSyncProgress)
            
            if fileExists() { os_log("Successfully initiated new sync status file", log: .repository, type: .info) }
        }
    }
    
    private static func fileExists() -> Bool {
        do {
            let _ = try Data(contentsOf: fileUrl)
            print(fileUrl)
            return true
        } catch {
            return false
        }
    }
}
