//
//  CategoryRepository.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/18/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

class CategoryRepository {
    
    private var latestCategories: [Category] = []
    var isStale = true
    
    init() { }
    
    func getLatestCategories() -> [Category] {
        if !isStale, !latestCategories.isEmpty {
            return latestCategories
        } else {
            CategoryApiService.fetchCategories { (categories, error) in
                guard error == nil else { return }
                if let data = categories {
                    self.latestCategories = data
                }
            }
        }
        return latestCategories
    }
}
