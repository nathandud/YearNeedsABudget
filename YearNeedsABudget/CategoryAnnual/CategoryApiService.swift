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
    
    static func fetchMonthlySummary(month: Int, year: Int? = nil, _ onCompletion: @escaping (MonthlyBudgetSummary?, String?) -> ()) {
        guard let monthString = YnabCalendar.getFirstDayOfMonth(month, year: year) else {
            fatalError("Invalid month could not be parsed by YnabCalendar")
        }
        
        //TODO: Store the budget id in the keychain (is this necessary? probably not since it's a URL parameter)
        let endpoint = "\(Scratch.baseUrl)/budgets/\(Scratch.selectedBudgetId)/months/\(monthString)"
        Networking.sendRequest(httpMethod: .get, endpoint: endpoint, httpBody: nil, onCompletion: { response in
            do {
                let categories = try JSONDecoder().decode(CategoriesByMonthDataClass.self, from: response)
                os_log("Successfully fetched data for %{PUBLIC}@ categories for %{PUBLIC}@", log: .networking, type: .info, "\(categories.data.month.categories?.count ?? 0)", monthString)
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
