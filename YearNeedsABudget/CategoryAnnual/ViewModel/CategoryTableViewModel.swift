//
//  CategoryTableViewElementModel.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 4/29/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

class CategoryTableViewModel {
    
    let name: String
    let spentThisMonth: Int
    let spentThisYear: Int
    let budgetedThisYear: Int
    let percentSpent: Double
    let percentOfYear: Double
    
    private let annualSummary: CategoryAnnualSummary
    
    init(annualSummary: CategoryAnnualSummary) {
        self.annualSummary = annualSummary
        name = annualSummary.name
        spentThisMonth = (annualSummary.months.last?.activity ?? 0)
        spentThisYear = annualSummary.spent
        budgetedThisYear = annualSummary.budgeted
        percentSpent = Double(annualSummary.spent) / Double(annualSummary.budgeted)
        
        //TODO: Getting day of year should be moved to Date utility class (which also needs to be renamed)
        if let dayNumber = Calendar.current.ordinality(of: .day, in: .year, for: Date()) {
            percentOfYear = Double(dayNumber) / 365
        } else {
            percentOfYear = Double(annualSummary.months.count / 12)
        }
        
        //TODO: Formatting of number, also should probably be in utility class
    }
}
