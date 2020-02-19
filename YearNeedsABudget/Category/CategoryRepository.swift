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
    var isStale = false
    
    init() { }
    
    func getLatestCategories() -> [Category] {
        if !isStale, !latestCategories.isEmpty {
            return latestCategories
        } else {
            fetchCategories()
        }
        return latestCategories
    }
    
    private func fetchCategories() {
        
    }
}
