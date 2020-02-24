//
//  CategoryViewModel.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/9/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

struct CategoryViewModel: CategoryObserver {
    var uuid: UUID
    var categories: [Category] = []
    private let repository: CategoryRepository
    private var onDataRefresh: ((Bool) -> Void)?
    
    init(repository: CategoryRepository) {
        self.repository = repository
        self.uuid = UUID()
    }
    
    mutating func refreshData(onCompletion: @escaping (Bool) -> Void) {
        categories = repository.getLatestCategories()
        onDataRefresh = onCompletion
    }
    
    func categoriesReturned(successfully: Bool) {
        print("Categories Returned: \(repository.getLatestCategories().count)")
        if let completion = onDataRefresh { completion(successfully) }
    }
}
