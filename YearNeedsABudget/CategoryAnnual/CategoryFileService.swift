//
//  CategoryFileService.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 4/20/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation
import os.log

struct CategoryFileService {
    
    static func saveMonthlyBudgetSummaries(_ monthlySummaries: [MonthlyBudgetSummary]) {
        guard let month = monthlySummaries.first?.month else {
            os_log("No monthly summaries to save", log: .filesystem, type: .info)
            return
        }
        
        os_log("Saving monthly summaries for %{PUBLIC}@", log: .filesystem, type: .info, monthlySummaries.reduce("") { "\($0),\($1)" })
        
        do {
            let jsonData = try JSONEncoder().encode(monthlySummaries)
            try jsonData.write(to: getFileUrl(month), options: [.completeFileProtection, .atomic])
            os_log("Saved monthly summaries file for %{PUBLIC}@", log: .filesystem, type: .info, month)
        } catch {
            os_log("Failed to save monthly summaries: %{PUBLIC}@", log: .filesystem, type: .error, error.localizedDescription)
        }
    }
    
    static func getMonthlyBudgetSummaries(for year: Int) -> [MonthlyBudgetSummary] {
        let fileEnumerator = FileManager.default.enumerator(at: getFolderUrl(for: year), includingPropertiesForKeys: nil)
        let decoder = JSONDecoder()
        
        guard let urls = fileEnumerator?.allObjects as? [URL] else {
            os_log("Failed to cast all directory objects to URLs", log: .filesystem, type: .error)
            return []
        }
        
        return urls.compactMap {
            do {
                let json = try Data(contentsOf: $0)
                return try decoder.decode(MonthlyBudgetSummary.self, from: json)
            } catch {
                return nil
            }
        }
    }

    private static func getFileUrl(_ month: String) -> URL {
        let year = YnabDateFormatter.shared.getYear(from: month) ?? YnabCalendar.currentYear //TODO: This is failable, should make it failable
        return getFolderUrl(for: year).appendingPathComponent("\(month).json")
    }
    
    private static func getFolderUrl(for year: Int) -> URL {
        return getUserDirectoryUrl().appendingPathComponent("\(year)", isDirectory: true)
    }
    
    private static func getUserDirectoryUrl() -> URL {
         return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
