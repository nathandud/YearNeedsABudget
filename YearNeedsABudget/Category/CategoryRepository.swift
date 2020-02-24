//
//  CategoryRepository.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/18/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

protocol Observerable {
    func addObserver(observer: CategoryObserver)
    func removeObserver(observer: CategoryObserver)
}

protocol CategoryObserver {
    var uuid: UUID { get }
    func categoriesReturned(successfully: Bool)
}

class CategoryRepository: Observerable {
    func addObserver(observer: CategoryObserver) {
        observers[observer.uuid] = observer
    }
    
    func removeObserver(observer: CategoryObserver) {
        observers.removeValue(forKey: observer.uuid)
    }
    
    private var latestCategories: [Category] = []
    private var observers = [UUID: CategoryObserver]()
    var isStale = true
    
    init() { }
    
    func getLatestCategories() -> [Category] {
        if isStale || latestCategories.isEmpty {
            CategoryApiService.fetchCategories { (categories, error) in
                guard error == nil else { return self.broadcastCompletion(with: false) }
                if let data = categories {
                    self.latestCategories = data
                    self.broadcastCompletion(with: true)
                }
            }
        }
        return latestCategories
    }
    
    private func broadcastCompletion(with success: Bool) {
        observers.values.forEach { $0.categoriesReturned(successfully: success) }
    }
}


