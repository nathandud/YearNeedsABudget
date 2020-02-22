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
    
    static func fetchCategories(_ onCompletion: @escaping ([Category]?, String?) -> ()) {
        #if MOCK
        print("Using mock data")
        #endif
        
        //TODO: Create a date formatter singleton class and use to populate the date format here at the end
        //TODO: Import a keychain library for storing the budget ID
        let endpoint = "https://api.youneedabudget.com/v1/budgets/ca809e4e-2690-4d42-a033-c52a01840d4b/months/2020-01-01"
        Networking.sendRequest(httpMethod: .get, endpoint: endpoint, httpBody: nil, onCompletion: { response in
            do {
                let categories = try JSONDecoder().decode(CategoriesByMonthDataClass.self, from: response)
                os_log("Successfully returned data for %{PUBLIC}@ categories", log: .networking, type: .info, categories.data.month.categories?.count ?? 0)
                onCompletion(categories.data.month.categories, nil)
            } catch {
                os_log("Could not parse categories JSON response")
            }
        }, onError: { message in
            os_log("%{PUBLIC}@", log: .networking, type: .error, message)
            onCompletion(nil, message)
        })
    }
    

}
