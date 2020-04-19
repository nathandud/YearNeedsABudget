//
//  CategoryViewModel.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/9/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

class CategoryViewModel: Observer {
    
    var uuid: UUID
    var categories: [CategoryAnnualSummary] = []
    private let repository: CategoryRepository
    private var onDataRefresh: ((Bool) -> Void)?
    
    init(repository: CategoryRepository) {
        self.repository = repository
        self.uuid = UUID()
        self.repository.addObserver(observer: self) { (result) in
            self.categories = repository.getLatestCategories()
            self.onDataRefresh?(result)
        }
    }
    
    func refreshData(onCompletion: @escaping (Bool) -> Void) {
        categories = repository.getLatestCategories()
        onDataRefresh = onCompletion
    }
    
    deinit {
        repository.removeObserver(observer: self)
    }
}
