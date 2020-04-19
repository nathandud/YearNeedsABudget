//
//  YnabDateFormatter.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/24/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

class YnabDateFormatter {
    
    static let shared = YnabDateFormatter()
    
    private let dayFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    private init() {
        dayFormatter = DateFormatter()
        dayFormatter.timeZone = TimeZone(identifier: "UTC")
        dayFormatter.dateFormat = "yyyy-MM-dd"
        
        timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(identifier: "UTC")
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    func getFirstDayOfMonth(_ month: Int, year: Int? = nil) -> String? {
        let calendarYear = year ?? Calendar.current.component(.year, from: Date())
        if let firstDay = Calendar.current.date(from: DateComponents(year: calendarYear, month: month, day: 1)) {
            return dayFormatter.string(from: firstDay)
        }
        return nil
    }
    
    func getMonthNumber(from day: String) -> Int? {
        if let date = dayFormatter.date(from: day) {
            return Calendar.current.component(.month, from: date)
        } else if let date = timeFormatter.date(from: day) {
            return Calendar.current.component(.month, from: date)
        } else {
            return nil
        }
    }
    
    func getTimestamp(_ date: Date = Date()) -> String {
        return timeFormatter.string(from: date)
    }
    
    func getDate(timestamp: String) -> Date? {
        return timeFormatter.date(from: timestamp)
    }
}
