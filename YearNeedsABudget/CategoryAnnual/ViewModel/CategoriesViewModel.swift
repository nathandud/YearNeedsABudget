//
//  CategoryViewModel.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/9/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

class CategoriesViewModel: Observer {
    
    var uuid: UUID
    var tableViewModels: [CategoryTableViewModel] = []
    private let repository: CategoryRepository
    private var onDataRefresh: ((Bool) -> Void)?
    
    init(repository: CategoryRepository) {
        self.repository = repository
        self.uuid = UUID()
        self.repository.addObserver(observer: self) { (result) in
            self.tableViewModels = repository.getLatestCategories().map { CategoryTableViewModel(annualSummary: $0) }
            self.onDataRefresh?(result)
        }
    }
    
    func refreshData(onCompletion: @escaping (Bool) -> Void) {
        tableViewModels = repository.getLatestCategories().map { CategoryTableViewModel(annualSummary: $0) }
        onDataRefresh = onCompletion
    }
    
    deinit {
        repository.removeObserver(observer: self)
    }
}
