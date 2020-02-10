//
//  Category.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/9/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct DataClass: Codable {
    let month: Month

    enum CodingKeys: String, CodingKey {
        case month = "month"
    }
}

/// MARK: - Month
struct Month: Codable {
    let month: String
    let note: String?
    let income: Int
    let budgeted: Int
    let activity: Int
    let toBeBudgeted: Int
    let ageOfMoney: Int
    let deleted: Bool
    let categories: [Category]

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
    let categoryGroupID: String
    let name: String
    let hidden: Bool
    let originalCategoryGroupID: String?
    let note: String?
    let budgeted: Int
    let activity: Int
    let balance: Int
    let goalType: String?
    let goalCreationMonth: String?
    let goalTarget: Int
    let goalTargetMonth: String?
    let goalPercentageComplete: String?
    let deleted: Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case categoryGroupID = "category_group_id"
        case name = "name"
        case hidden = "hidden"
        case originalCategoryGroupID = "original_category_group_id"
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
