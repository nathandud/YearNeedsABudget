//
//  CategoryRepository.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/18/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

class CategoryRepository {
    
    private var latestCategories: [CategoryAnnualSummary]
    private var monthlySyncReports: [MonthlySyncReport]
    private var fetchedMonthlySummaries: [MonthlyBudgetSummary]
    private var cachedMonthlySummaries: [MonthlyBudgetSummary]
    
    private let budgetSummaryAccessQueue = DispatchQueue.init(label: "categoryRepo.monthlySummaryAccessQueue", attributes: .concurrent)
    private let syncReportAccessQueue = DispatchQueue.init(label: "categoryRepo.syncReportAccessQueue", attributes: .concurrent)
    
    private var error: String? = nil
    private var observers = [UUID: (Bool) -> Void]()
    
    init() {
        fetchedMonthlySummaries = []
        cachedMonthlySummaries = CategoryFileService.getMonthlyBudgetSummaries(for: YnabCalendar.currentYear)
        monthlySyncReports = SyncService.getYearlySyncSummary(for: YnabCalendar.currentYear)?.monthlyReports ?? []
        latestCategories = CategoryAggregator.aggregate(monthlyBudgetSummaries: cachedMonthlySummaries)
    }
    
    //MARK: - Public
    
    func getLatestCategories(for year: Int = YnabCalendar.currentYear) -> [CategoryAnnualSummary] {
        let staleMonths = getMonthsNeedingRefresh(for: year)
        if !staleMonths.isEmpty || latestCategories.isEmpty {
            latestCategories.removeAll()
            fetchLatestAnnualCategoryData(for: year, staleMonths: staleMonths)
        }
        return latestCategories
    }
    
    //MARK: - Private
    
    private func getMonthsNeedingRefresh(for year: Int = YnabCalendar.currentYear) -> [Int] {
        return monthlySyncReports.compactMap { (monthlySyncReport) -> Int? in
            return SyncService.getUpdatedSyncStatus(for: monthlySyncReport) != .upToDate ? monthlySyncReport.month : nil
        }
    }
    
    private func fetchLatestAnnualCategoryData(for year: Int = YnabCalendar.currentYear, staleMonths: [Int] = []) {
        self.error = nil
        for month in staleMonths {
            guard error == nil else {
                runFetchCompletion(for: year, error: error)
                return
            }
            
            fetchMonthlySummary(for: month) { error in
                self.error = error
                if self.isUpdateComplete(requestCount: staleMonths.count) {
                    self.runFetchCompletion(for: year, error: error)
                }
            }
        }
    }
    
    private func fetchMonthlySummary(for month: Int, _ completion: ((String?) -> Void)? = nil) {
        CategoryApiService.fetchMonthlySummary(month: month) { (monthlySummary, error) in
            var syncStatus: SyncStatus
            if let summary = monthlySummary, error == nil {
                self.addMonthlyBudgetSummary(summary)
                syncStatus = .upToDate
            } else {
                syncStatus = .failed
            }
            
            self.updateMonthlySyncReport(for: month, syncStatus: syncStatus)
            completion?(error)
        }
    }
    
    private func addMonthlyBudgetSummary(_ monthlySummary: MonthlyBudgetSummary) {
        budgetSummaryAccessQueue.sync(flags: .barrier) {
            fetchedMonthlySummaries.append(monthlySummary)
        }
    }
    
    private func updateMonthlySyncReport(for month: Int, syncStatus: SyncStatus) {
        syncReportAccessQueue.sync(flags: .barrier) {
            monthlySyncReports.removeAll(where: { $0.month == month })
            monthlySyncReports.append(MonthlySyncReport(month, status: syncStatus))
        }
    }
    
    private func isUpdateComplete(requestCount: Int) -> Bool {
        return fetchedMonthlySummaries.count == requestCount || error != nil
    }
    
    private func runFetchCompletion(for year: Int, error: String? = nil) {
        SyncService.saveYearlySyncSummary(YearlySyncSummary(year, monthlyReports: monthlySyncReports))
        
        updateCachedBudgetSummaries(with: fetchedMonthlySummaries)
        fetchedMonthlySummaries.removeAll()
        
        if error != nil {
            broadcastCompletion(with: false)
        } else {
            latestCategories = CategoryAggregator.aggregate(monthlyBudgetSummaries: cachedMonthlySummaries)
            broadcastCompletion(with: true)
        }
    }
    
    private func updateCachedBudgetSummaries(with fetchedMonthlySummaries: [MonthlyBudgetSummary]) {
        guard let monthString = fetchedMonthlySummaries.first?.month,
            let year = YnabCalendar.getMonth(from: monthString) else { return }
            cachedMonthlySummaries = Array(1...YnabCalendar.elapsedMonths(year: year)).compactMap { (monthNumber) -> MonthlyBudgetSummary? in
                let fetchedSummary = fetchedMonthlySummaries.first { YnabCalendar.getMonth(from: $0.month) == monthNumber }
            let cachedSummary = cachedMonthlySummaries.first { YnabCalendar.getMonth(from: $0.month) == monthNumber }
            return fetchedSummary ?? cachedSummary
        }
        CategoryFileService.saveMonthlyBudgetSummaries(cachedMonthlySummaries)
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


