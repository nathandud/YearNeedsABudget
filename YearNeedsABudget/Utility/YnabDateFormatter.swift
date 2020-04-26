//
//  YnabDateFormatter.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/24/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

struct YnabDateFormatter {
    
    static let shared = YnabDateFormatter()
    
    private let dayFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    private var utcCalendar: Calendar
    
    private init() {
        let utc = TimeZone(identifier: "UTC") ?? Calendar.current.timeZone
        
        dayFormatter = DateFormatter()
        dayFormatter.timeZone = utc
        dayFormatter.dateFormat = "yyyy-MM-dd"
        
        timeFormatter = DateFormatter()
        timeFormatter.timeZone = utc
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        utcCalendar = Calendar(identifier: .gregorian)
        utcCalendar.timeZone = utc
    }
    
    func getFirstDayOfMonth(_ month: Int, year: Int? = nil) -> String? {
        let calendarYear = year ?? YnabDateComponents.currentYear
        if let firstDay = utcCalendar.date(from: DateComponents(year: calendarYear, month: month, day: 1)) {
            return dayFormatter.string(from: firstDay)
        }
        return nil
    }
    
    func getMonthNumber(from day: String) -> Int? {
        if let date = dayFormatter.date(from: day) {
            return utcCalendar.component(.month, from: date)
        } else if let date = timeFormatter.date(from: day) {
            return utcCalendar.component(.month, from: date)
        } else {
            return nil
        }
    }
    
    func getYear(from day: String) -> Int? {
       if let date = dayFormatter.date(from: day) {
           return utcCalendar.component(.year, from: date)
       } else if let date = timeFormatter.date(from: day) {
           return utcCalendar.component(.year, from: date)
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

struct YnabDateComponents {
    static let currentMonth = Calendar.current.component(.month, from: Date())
    static let currentYear = Calendar.current.component(.year, from: Date())
    static func elapsedMonths(in year: Int) -> Int {
        return year == currentYear ? currentMonth : 12
    }
}
