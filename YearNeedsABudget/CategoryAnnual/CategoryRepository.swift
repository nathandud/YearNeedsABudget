//
//  CategoryRepository.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/18/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

enum CompletionStatus {
    case inProgress
    case complete
    case error
}

class CategoryRepository {
    
    var isStale = true
    private var latestCategories: [CategoryAnnualSummary] = []
    private var monthlySummaries: [Int: MonthlyBudgetSummary] = [:]
    private var currentMonth = Calendar.current.component(.month, from: Date())
    private var error: String? = nil
    private var observers = [UUID: (Bool) -> Void]()
    
    init() { }
    
    func getLatestCategories() -> [CategoryAnnualSummary] {
        if isStale || latestCategories.isEmpty {
            latestCategories.removeAll()
            fetchLatestAnnualCategoryData()
        }
        return latestCategories
    }
    
    private func fetchLatestAnnualCategoryData() {
        self.error = nil
        for month in 1...currentMonth {
            guard error == nil else { break }
            fetchMonthlySummary(for: month) { error in
                guard error == nil else {
                    self.isStale = true
                    self.broadcastCompletion(with: false)
                    return
                }
                guard self.isUpdateComplete() else { return }
                self.latestCategories = CategoryAggregator.aggregate(monthlyBudgetSummaries: Array(self.monthlySummaries.values))
                self.isStale = false
                self.broadcastCompletion(with: true)
            }
        }
    }
    
    private func isUpdateComplete() -> Bool {
        return monthlySummaries.count == currentMonth && error == nil
    }
    
    private func getMonthsNeedingRefresh() -> [Int] {
        guard let syncStatus = SyncStatusService.fetchYearlySyncSummary() else { return [] }
        return syncStatus.monthlyStatuses.compactMap { (monthStatus) -> Int? in
            guard monthStatus.status != .upToDate else { return nil }
            return monthStatus.month
        }
    }
    
    private func fetchMonthlySummary(for month: Int, _ completion: ((String?) -> Void)? = nil) {
        CategoryApiService.fetchMonthlySummary(month: month) { (monthlySummary, error) in
            guard error == nil else {
                self.error = error
                return
            }
            self.monthlySummaries[month] = monthlySummary
            completion?(error)
        }
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


