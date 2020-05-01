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
    let spentThisYearLabelText: String?
    let budgetedThisYearLabelText: String?
    let spendingTarget: Int
    let percentSpent: Double
    let percentOfYear: Double
    
    private let annualSummary: CategoryAnnualSummary
    
    init(annualSummary: CategoryAnnualSummary) {
        self.annualSummary = annualSummary
        nameLabelText = annualSummary.name
        spentThisYearLabelText = YnabMoney.getCurrencyString(serverAmount: annualSummary.spent)
        budgetedThisYearLabelText = YnabMoney.getCurrencyString(serverAmount: annualSummary.budgeted)
        spendingTarget = annualSummary.spendingTarget
        percentSpent = Double(annualSummary.spent) / Double(annualSummary.spendingTarget)
        percentOfYear = Double(YnabCalendar.elapsedDays(year: annualSummary.year)) / Double(YnabCalendar.totalDays(year: annualSummary.year))
    }
}
