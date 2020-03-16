//
//  CategoryAnnualSummary.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/24/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

struct CategoryAnnualSummary {
    let categoryId: String
    let categoryGroupId: String
    let name: String
    let budgeted: Int
    let activity: Int
    let balance: Int
    let months: [MonthlySummary]
    
    init(categoryId: String, categoryGroupId: String, name: String, budgeted: Int, activity: Int, balance: Int, months: [MonthlySummary]) {
        self.categoryId = categoryId
        self.categoryGroupId = categoryGroupId
        self.name = name
        self.budgeted = budgeted
        self.activity = activity
        self.balance = balance
        self.months = months
    }
}
