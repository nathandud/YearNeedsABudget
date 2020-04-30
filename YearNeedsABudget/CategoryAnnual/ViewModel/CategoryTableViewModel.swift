//
//  CategoryTableViewElementModel.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 4/29/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

class CategoryTableViewModel {
    
    let nameLabelText: String
    let spentThisMonthLabelText: String?
    let spentThisYearLabelText: String?
    let budgetedThisYearLabelText: String?
    let percentSpent: Double
    let percentOfYear: Double
    
    private let annualSummary: CategoryAnnualSummary
    
    init(annualSummary: CategoryAnnualSummary) {
        self.annualSummary = annualSummary
        nameLabelText = annualSummary.name
        spentThisMonthLabelText = YnabMoney.getCurrencyString(serverAmount: annualSummary.months.last?.activity ?? 0) //TODO: The months might not be in order
        spentThisYearLabelText = YnabMoney.getCurrencyString(serverAmount: annualSummary.spent)
        budgetedThisYearLabelText = YnabMoney.getCurrencyString(serverAmount: annualSummary.budgeted)
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
