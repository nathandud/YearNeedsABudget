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
    private var monthSyncStatuses: [MonthSyncStatus] = []
    
    private var error: String? = nil
    private var observers = [UUID: (Bool) -> Void]()
    
    init() {
        //TODO: Pickup here
//        monthlySummaries = CategoryFileService.getMonthlyBudgetSummaries(for: YnabCalendar.currentYear)
//        latestCategories = CategoryAggregator.aggregate(monthlyBudgetSummaries: Array(monthlySummaries.values))
    }
    
    func getLatestCategories() -> [CategoryAnnualSummary] {
        if isStale || latestCategories.isEmpty {
            latestCategories.removeAll()
            fetchLatestAnnualCategoryData()
        }
        return latestCategories
    }
    
    private func fetchLatestAnnualCategoryData(for year: Int = YnabCalendar.currentYear) {
        self.error = nil
        let months = getMonthsNeedingRefresh()
        for month in months {
            guard error == nil else { break }
            fetchMonthlySummary(for: month) { error in
                guard self.isUpdateComplete(monthsRequested: months.count) else { return }
                
                self.error = error
                SyncStatusService.saveYearlySyncSummary(YearlySyncSummary(year, monthlyStatuses: self.monthSyncStatuses))
                
                if error != nil {
                    self.broadcastCompletion(with: false)
                } else {
                    self.latestCategories = CategoryAggregator.aggregate(monthlyBudgetSummaries: Array(self.monthlySummaries.values))
                    self.isStale = false
                    self.broadcastCompletion(with: true)
                }
            }
        }
    }
    
    private func getMonthsNeedingRefresh() -> [Int] {
        guard let syncStatus = SyncStatusService.getYearlySyncSummary() else { return [] }
        return syncStatus.monthlyStatuses.compactMap { (monthStatus) -> Int? in
            guard monthStatus.status != .upToDate else { return nil }
            return monthStatus.month
        }
    }
    
    private func fetchMonthlySummary(for month: Int, _ completion: ((String?) -> Void)? = nil) {
        var syncStatus = SyncStatus.inProgress
        CategoryApiService.fetchMonthlySummary(month: month) { (monthlySummary, error) in
            if error != nil {
                syncStatus = .failed
            } else {
                syncStatus = .upToDate
                self.monthlySummaries[month] = monthlySummary
            }
            self.monthSyncStatuses.append(MonthSyncStatus(month, status: syncStatus))
            completion?(error)
        }
    }
    
    private func isUpdateComplete(monthsRequested: Int) -> Bool {
        return monthlySummaries.count == monthsRequested || error != nil
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


