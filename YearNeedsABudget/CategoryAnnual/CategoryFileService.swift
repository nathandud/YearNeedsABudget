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
        guard let monthString = monthlySummaries.first?.month, let year = YnabDateFormatter.shared.getYear(from: monthString) else {
            os_log("No monthly summaries to save", log: .filesystem, type: .info)
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(monthlySummaries)
            try jsonData.write(to: getFileUrl(year), options: [.completeFileProtection, .atomic])
            os_log("Saved monthly summaries file for %{PUBLIC}@", log: .filesystem, type: .info, "\(year)")
        } catch {
            os_log("Failed to save monthly summaries for %{PUBLIC}@: %{PUBLIC}@", log: .filesystem, type: .error, "\(year)", error.localizedDescription)
        }
    }
    
    static func getMonthlyBudgetSummaries(for year: Int) -> [MonthlyBudgetSummary] {
        do {
            let json = try Data(contentsOf: getFileUrl(year))
            return try JSONDecoder().decode([MonthlyBudgetSummary].self, from: json)
        } catch {
            os_log("Failed to retrieve monthly summaries for %{PUBLIC}@: %{PUBLIC}@", log: .filesystem, type: .error, "\(year)", error.localizedDescription)
            return []
        }
    }

    private static func getFileUrl(_ year: Int) -> URL {
        return getDocumentsDirectory().appendingPathComponent("bs-\(year).json")
    }
    
    private static func getDocumentsDirectory() -> URL {
         return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
