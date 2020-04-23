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
    
    
    private var latestCategories: [CategoryAnnualSummary]
    private var monthSyncStatuses: [MonthSyncStatus]
    private var fetchedMonthlySummaries: [MonthlyBudgetSummary]
    private var cachedMonthlySummaries: [MonthlyBudgetSummary]
    
    private var error: String? = nil
    private var observers = [UUID: (Bool) -> Void]()
    
    init() {
        fetchedMonthlySummaries = []
        cachedMonthlySummaries = CategoryFileService.getMonthlyBudgetSummaries(for: YnabCalendar.currentYear)
        monthSyncStatuses = SyncStatusService.getYearlySyncSummary(for: YnabCalendar.currentYear)?.monthlyStatuses ?? []
        latestCategories = CategoryAggregator.aggregate(monthlyBudgetSummaries: cachedMonthlySummaries)
    }
    
    func getLatestCategories(for year: Int = YnabCalendar.currentYear) -> [CategoryAnnualSummary] {
        let staleMonths = getMonthsNeedingRefresh(for: year)
        if !staleMonths.isEmpty || latestCategories.isEmpty {
            latestCategories.removeAll()
            fetchLatestAnnualCategoryData(for: year, staleMonths: staleMonths)
        }
        return latestCategories
    }
    
    private func getMonthsNeedingRefresh(for year: Int = YnabCalendar.currentYear) -> [Int] {
        monthSyncStatuses = SyncStatusService.getRefreshedSyncStatus(for: monthSyncStatuses)
        return monthSyncStatuses.compactMap { (monthStatus) -> Int? in
            guard monthStatus.status != .upToDate else { return nil }
            return monthStatus.month
        }
    }
    
    private func fetchLatestAnnualCategoryData(for year: Int = YnabCalendar.currentYear, staleMonths: [Int] = []) {
        self.error = nil
        for month in staleMonths {
            guard error == nil else {
                runCompletion(for: year, error: error)
                return
            }
            
            fetchMonthlySummary(for: month) { error in
                self.error = error
                if self.isUpdateComplete(requestCount: staleMonths.count) {
                    self.runCompletion(for: year, error: error)
                }
            }
        }
    }
    
    private func fetchMonthlySummary(for month: Int, _ completion: ((String?) -> Void)? = nil) {
        var syncStatus = SyncStatus.inProgress
        CategoryApiService.fetchMonthlySummary(month: month) { (monthlySummary, error) in
            if let summary = monthlySummary, error == nil {
                syncStatus = .upToDate
                self.fetchedMonthlySummaries.append(summary)
            } else {
                syncStatus = .failed
            }
            self.monthSyncStatuses.append(MonthSyncStatus(month, status: syncStatus))
            completion?(error)
        }
    }
    
    private func isUpdateComplete(requestCount: Int) -> Bool {
        return fetchedMonthlySummaries.count == requestCount || error != nil
    }
    
    private func runCompletion(for year: Int, error: String? = nil) {
        SyncStatusService.saveYearlySyncSummary(YearlySyncSummary(year, monthlyStatuses: self.monthSyncStatuses))
        fetchedMonthlySummaries.removeAll()
        
        if error != nil {
            self.broadcastCompletion(with: false)
        } else {
            self.latestCategories = CategoryAggregator.aggregate(monthlyBudgetSummaries: Array(self.cachedMonthlySummaries))
            CategoryFileService.saveMonthlyBudgetSummaries(self.cachedMonthlySummaries)
            self.broadcastCompletion(with: true)
        }
    }
    
    private func broadcastCompletion(with result: Bool) {
        observers.values.forEach { closure in
            closure(result)
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


