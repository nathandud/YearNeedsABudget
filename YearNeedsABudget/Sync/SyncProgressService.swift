//
//  SyncProgressService.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 3/8/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation
import os.log

struct SyncProgressService {
    
    private static let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("sync_progress.json")
    
    static func fetchSyncProgress(for year: Int) -> SyncProgressYear? {
        do {
            let json = try Data(contentsOf: fileUrl)
            let syncProgress = try JSONDecoder().decode([SyncProgressYear].self, from: json)
            return syncProgress.first { $0.year == year }
        } catch {
            os_log("Failed to fetch sync progress year %{PUBLIC}@: %{PUBLIC}@", log: .repository, type: .error, "\(year)", error.localizedDescription)
            return nil
        }
    }
    
    static func saveSyncProgress(_ jsonData: Data) {
        
    }
    
    
    static func initializeSyncProgressFile() {
        if !fileExists() {
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            var syncMonths: [SyncProgressMonth] = []
            
            for month in 1...currentMonth {
                let monthSyncProgress = SyncProgressMonth(month: month)
                syncMonths.append(monthSyncProgress)
            }
            
            let yearSyncProgress = SyncProgressYear(year: currentYear, syncProgressMonths: syncMonths)
            do {
                let jsonData = try JSONEncoder().encode(yearSyncProgress)
                try jsonData.write(to: fileUrl, options: [.completeFileProtection, .atomic])
                os_log("Successfully initiated new sync status file", log: .repository, type: .info)
            } catch {
                os_log("Failed to create new sync status file: %{PUBLIC}@", log: .repository, type: .error, error.localizedDescription)
            }
            
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
