//
//  YNABCategoriesByMonthDataClass.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/9/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//
// Modified from file generated by https://app.quicktype.io/

import Foundation

//This class represents the top-level object returned from the Categories Endpoint
struct CategoriesByMonthDataClass: Codable {
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct DataClass: Codable {
    let month: MonthlyBudgetSummary

    enum CodingKeys: String, CodingKey {
        case month = "month"
    }
}

// MARK: - Month
struct MonthlyBudgetSummary: Codable {
    let month: String
    let note: String?
    let income: Int
    let budgeted: Int
    let activity: Int
    let toBeBudgeted: Int
    let ageOfMoney: Int
    let deleted: Bool
    let categories: [Category]?

    enum CodingKeys: String, CodingKey {
        case month = "month"
        case note = "note"
        case income = "income"
        case budgeted = "budgeted"
        case activity = "activity"
        case toBeBudgeted = "to_be_budgeted"
        case ageOfMoney = "age_of_money"
        case deleted = "deleted"
        case categories = "categories"
    }
}

// MARK: - Category
struct Category: Codable {
    let id: String
    let categoryGroupId: String
    let name: String
    let hidden: Bool
    let originalCategoryGroupId: String?
    let note: String?
    let budgeted: Int
    let activity: Int
    let balance: Int
    let goalType: String?
    let goalCreationMonth: String?
    let goalTarget: Int
    let goalTargetMonth: String?
    let goalPercentageComplete: Int?
    let deleted: Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case categoryGroupId = "category_group_id"
        case name = "name"
        case hidden = "hidden"
        case originalCategoryGroupId = "original_category_group_id"
        case note = "note"
        case budgeted = "budgeted"
        case activity = "activity"
        case balance = "balance"
        case goalType = "goal_type"
        case goalCreationMonth = "goal_creation_month"
        case goalTarget = "goal_target"
        case goalTargetMonth = "goal_target_month"
        case goalPercentageComplete = "goal_percentage_complete"
        case deleted = "deleted"
    }
}
