//
//  CategoryRepository.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/18/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation



class CategoryRepository: Observerable {

    func addObserver(observer: Observer, closure: @escaping (Bool) -> Void) {
        observers[observer.uuid] = closure
    }
    
    func removeObserver(observer: Observer) {
        observers.removeValue(forKey: observer.uuid)
    }
    
    private var latestCategories: [Category] = []
    private var observers = [UUID: (Bool) -> Void]()
    var isStale = true
    
    init() { }
    
    func getLatestCategories() -> [Category] {
        if isStale || latestCategories.isEmpty {
            CategoryApiService.fetchCategories { (categories, error) in
                guard error == nil else { return self.broadcastCompletion(with: false) }
                if let data = categories {
                    self.latestCategories = data
                    self.isStale = false
                    self.broadcastCompletion(with: true)
                }
            }
        }
        return latestCategories
    }
    
    private func broadcastCompletion(with success: Bool) {
        observers.values.forEach { closure in
            closure(success)
        }
    }
}


