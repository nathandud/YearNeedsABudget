//
//  CategoryApiService.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/18/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation
import os.log

struct CategoryApiService {
    
    static func fetchMonthlySummary(month: Int, year: Int? = nil, _ onCompletion: @escaping (MonthlySummary?, String?) -> ()) {
        guard let monthString = YnabDateFormatter.shared.getFirstDayOfMonth(month, year: year) else {
            fatalError("Invalid month sent to YnabDateFormatter")
        }
        
        //TODO: Import a keychain library for storing the budget ID
        let endpoint = "\(Scratch.baseUrl)/budgets/\(Scratch.selectedBudgetId)/months/\(monthString)"
        Networking.sendRequest(httpMethod: .get, endpoint: endpoint, httpBody: nil, onCompletion: { response in
            do {
                let categories = try JSONDecoder().decode(CategoriesByMonthDataClass.self, from: response)
                os_log("Successfully returned data for %{PUBLIC}@ categories", log: .networking, type: .info, "\(categories.data.month.categories?.count ?? 0)")
                onCompletion(categories.data.month, nil)
            } catch {
                os_log("Could not parse categories JSON response: %{PUBLIC}@", log: .networking, type: .error, error.localizedDescription)
            }
        }, onError: { message in
            os_log("%{PUBLIC}@", log: .networking, type: .error, message)
            onCompletion(nil, message)
        })
    }
}
