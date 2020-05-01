//
//  CategoryAnnualSummary.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/24/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

struct CategoryAnnualSummary {
    let year: Int
    let categoryId: String
    let categoryGroupId: String
    let name: String
    let budgeted: Int
    let spent: Int
    let spendingTarget: Int = 2000000
    let hidden: Bool
    let months: [CategoryMonthlySummary]
    
    init(year: Int, categoryId: String, categoryGroupId: String, name: String, months: [CategoryMonthlySummary], hidden: Bool = false) {
        self.year = year
        self.categoryId = categoryId
        self.categoryGroupId = categoryGroupId
        self.name = name
        self.budgeted = months.reduce(0) { (result, monthlySummary) -> Int in return result + monthlySummary.budgeted  }
        self.spent = months.reduce(0) { $0 + $1.activity }
        self.months = months
        self.hidden = hidden
    }
}

struct CategoryMonthlySummary {
    let year: Int
    let month: Int
    let categoryId: String
    let categoryGroupId: String
    let name: String
    let budgeted: Int
    let activity: Int
    let hidden: Bool
    
    init(year: Int, month: Int, categoryId: String, categoryGroupId: String, name: String, budgeted: Int, spent: Int, hidden: Bool = false) {
        self.year = year
        self.month = month
        self.categoryId = categoryId
        self.categoryGroupId = categoryGroupId
        self.name = name
        self.budgeted = budgeted
        self.activity = spent
        self.hidden = hidden
    }
}

struct CategoryAggregator {
    static func aggregate(monthlyBudgetSummaries: [MonthlyBudgetSummary]) -> [CategoryAnnualSummary] {
        
        let categoryMonthlySummaries = monthlyBudgetSummaries.map { (monthlySummary) -> [CategoryMonthlySummary] in
            guard let categories = monthlySummary.categories, let month = YnabCalendar.getMonth(from: monthlySummary.month), let year = YnabCalendar.getYear(from: monthlySummary.month) else { return [] }
            return categories.map { (category) -> CategoryMonthlySummary in
                return CategoryMonthlySummary(year: year, month: month, categoryId: category.id, categoryGroupId: category.categoryGroupId, name: category.name, budgeted: category.budgeted, spent: category.activity, hidden: category.hidden)
            }
        }.flatMap { $0 }
        
        let groupedMonthlySummaries = Dictionary(grouping: categoryMonthlySummaries, by: { $0.categoryId })
        
        return groupedMonthlySummaries.compactMap { (categorySummaries) -> CategoryAnnualSummary? in
            guard let firstSummary = Array(categorySummaries.value).last else { return nil }
            return CategoryAnnualSummary(year: firstSummary.year, categoryId: categorySummaries.key, categoryGroupId: firstSummary.categoryGroupId, name: firstSummary.name, months: categorySummaries.value, hidden: firstSummary.hidden)
        }
    }
}
