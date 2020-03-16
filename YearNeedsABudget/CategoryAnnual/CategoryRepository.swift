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
    private var observers = [UUID: (Bool) -> Void]()
    var isStale = true
    
    init() { }
    
    private func loadSummariesIfNeeded() {
        //TODO:
        //Have some sort of dictionary with months and last refreshed times
        //Use logic to determine if any files are stale
        //Need a method to mark files as stale if user opts for some sort of full refresh
    }
    
    func getSyncStatuses() -> [String: SyncProgressMonth]? {
        return nil
    }
    
    func getLatestCategories() -> [Category] {
        if isStale || latestCategories.isEmpty {
            CategoryApiService.fetchMonthlySummary(month: 1 /* Change this out */) { (categories, error) in
                guard error == nil else { return self.broadcastCompletion(with: false) }
                if let data = categories {
                    self.latestCategories = data.categories! //Obviously need to change this later
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

extension CategoryRepository: Observerable {
    func addObserver(observer: Observer, closure: @escaping (Bool) -> Void) {
        observers[observer.uuid] = closure
    }
    
    func removeObserver(observer: Observer) {
        observers.removeValue(forKey: observer.uuid)
    }
}


