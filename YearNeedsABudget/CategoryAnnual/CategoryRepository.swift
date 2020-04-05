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
    
    func getMonthsNeedingRefresh() -> [Int] {
        guard let syncStatus = SyncStatusService.fetchYearlySyncSummary() else { return [] }
        return syncStatus.monthlyStatuses.compactMap { (monthStatus) -> Int? in
            guard monthStatus.status != .upToDate else { return nil }
            return monthStatus.month
        }
    }
    
    //TODO: Need to add a way to save the sync status when app is backgrounded. This will probably be in the scene delegate
    
    func getLatestCategories() -> [Category] {
        if isStale || latestCategories.isEmpty {
            CategoryApiService.fetchMonthlySummary(month: 1 /* Change this out */) { (montlySummary, error) in
                guard error == nil else { return self.broadcastCompletion(with: false) }
                if let categories = montlySummary?.categories {
                    self.latestCategories = categories //Obviously need to change this later
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


