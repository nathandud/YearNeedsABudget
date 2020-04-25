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
    let months: [CategoryMonthlySummary]
    
    init(categoryId: String, categoryGroupId: String, name: String, months: [CategoryMonthlySummary]) {
        self.categoryId = categoryId
        self.categoryGroupId = categoryGroupId
        self.name = name
        self.budgeted = months.reduce(0) { (result, monthlySummary) -> Int in return result + monthlySummary.budgeted  }
        self.activity = months.reduce(0) { $0 + $1.activity }
        self.months = months
    }
}

struct CategoryMonthlySummary {
    let month: Int
    let categoryId: String
    let categoryGroupId: String
    let name: String
    let budgeted: Int
    let activity: Int
    
    init(month: Int, categoryId: String, categoryGroupId: String, name: String, budgeted: Int, activity: Int) {
        self.month = month
        self.categoryId = categoryId
        self.categoryGroupId = categoryGroupId
        self.name = name
        self.budgeted = budgeted
        self.activity = activity
    }
}

struct CategoryAggregator {
    static func aggregate(monthlyBudgetSummaries: [MonthlyBudgetSummary]) -> [CategoryAnnualSummary] {
        
        let categoryMonthlySummaries = monthlyBudgetSummaries.map { (monthlySummary) -> [CategoryMonthlySummary] in
            guard let categories = monthlySummary.categories, let month = YnabDateFormatter.shared.getMonthNumber(from: monthlySummary.month) else { return [] }
            return categories.map { (category) -> CategoryMonthlySummary in
                return CategoryMonthlySummary(month: month, categoryId: category.id, categoryGroupId: category.categoryGroupId, name: category.name, budgeted: category.budgeted, activity: category.activity)
            }
        }.flatMap { $0 }
        
        let groupedMonthlySummaries = Dictionary(grouping: categoryMonthlySummaries, by: { $0.categoryId })
        
        return groupedMonthlySummaries.compactMap { (categorySummaries) -> CategoryAnnualSummary? in
            guard let firstSummary = Array(categorySummaries.value).last else { return nil }
            return CategoryAnnualSummary(categoryId: categorySummaries.key, categoryGroupId: firstSummary.categoryGroupId, name: firstSummary.name, months: categorySummaries.value)
        }
    }
}

struct BudgetSummaryAggregator {
    static func combine(cached: [MonthlyBudgetSummary], fetched: [MonthlyBudgetSummary]) -> [MonthlyBudgetSummary] {
        guard let monthString = cached.first?.month ?? fetched.first?.month, let year = YnabDateFormatter.shared.getYear(from: monthString) else { return [] }
        return Array(0...YnabCalendar.monthCount(for: year)).compactMap { (monthNumber) -> MonthlyBudgetSummary? in
            let fetchedSummary = fetched.first { $0.month == monthString }
            let cachedSummary = cached.first { $0.month == monthString }
            return fetchedSummary ?? cachedSummary
        }
    }
}
