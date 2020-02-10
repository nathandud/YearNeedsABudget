//
//  MockData.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/10/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

struct MockData {
    static let categoryJsonResponse =
    """
    {
        "data": {
            "month": {
                "month": "2020-01-01",
                "note": null,
                "income": 8405220,
                "budgeted": 8020430,
                "activity": -7928300,
                "to_be_budgeted": 0,
                "age_of_money": 23,
                "deleted": false,
                "categories": [
                    {
                        "id": "1f1ak111-eac1-111c-11ou-111n11111t11",
                        "category_group_id": "9fa99k99-9de9-9999-99gr-9o99u9999999",
                        "name": "Electricity",
                        "hidden": false,
                        "original_category_group_id": null,
                        "note": null,
                        "budgeted": 60000,
                        "activity": -120000,
                        "balance": 0,
                        "goal_type": "NEED",
                        "goal_creation_month": "2020-02-01",
                        "goal_target": 60000,
                        "goal_target_month": null,
                        "goal_percentage_complete": null,
                        "deleted": false
                    },
                    {
                        "id": "2f2ak222-eac2-222c-22ou-222n22222t22",
                        "category_group_id": "9fa99k99-9de9-9999-99gr-9o99u9999999",
                        "name": "Water",
                        "hidden": false,
                        "original_category_group_id": null,
                        "note": null,
                        "budgeted": 100000,
                        "activity": -83680,
                        "balance": 16320,
                        "goal_type": "NEED",
                        "goal_creation_month": "2020-02-01",
                        "goal_target": 100000,
                        "goal_target_month": null,
                        "goal_percentage_complete": null,
                        "deleted": false
                    },
                    {
                        "id": "3f3ak333-eac3-333c-33ou-333n33333t33",
                        "category_group_id": "9fa99k99-9de9-9999-99gr-9o99u9999999",
                        "name": "Internet",
                        "hidden": false,
                        "original_category_group_id": null,
                        "note": null,
                        "budgeted": 64000,
                        "activity": -63090,
                        "balance": 910,
                        "goal_type": "NEED",
                        "goal_creation_month": "2020-02-01",
                        "goal_target": 62000,
                        "goal_target_month": null,
                        "goal_percentage_complete": null,
                        "deleted": false
                    }
                ]
            }
        }
    }
    """.data(using: .utf8)
}
