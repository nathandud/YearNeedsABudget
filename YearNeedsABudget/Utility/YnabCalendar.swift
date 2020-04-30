//
//  YnabCalendar.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 4/29/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

struct YnabCalendar {
    static let currentMonth = Calendar.current.component(.month, from: Date())
    static let currentYear = Calendar.current.component(.year, from: Date())
    
    static func getFirstDayOfMonth(_ month: Int, year: Int? = nil) -> String? {
        return YnabDateFormatter.shared.getFirstDayOfMonth(month, year: year)
    }
    
    static func getYear(from day: String, format: YnabDateFormat = .serverDate) -> Int? {
        return YnabDateFormatter.shared.getDateComponent(from: day, component: .year, with: format)
    }
    
    static func getMonth(from day: String, format: YnabDateFormat = .serverDate) -> Int? {
        return YnabDateFormatter.shared.getDateComponent(from: day, component: .month, with: format)
    }
    
    static func getTimestamp(_ date: Date = Date()) -> String {
        return YnabDateFormatter.shared.getTimestamp(date)
    }
    
    static func getDate(timestamp: String) -> Date? {
        return YnabDateFormatter.shared.getDate(timestamp: timestamp)
    }
    
    static func elapsedMonths(in year: Int) -> Int {
        return year == currentYear ? currentMonth : 12
    }
}

enum YnabDateFormat: String {
    case serverDate = "yyyy-MM-dd"
    case serverTimestamp = "yyyy-MM-dd'T'HH:mm:ss"
}

fileprivate class YnabDateFormatter {
    
    static let shared = YnabDateFormatter()
    
    private let utc = TimeZone(identifier: "UTC") ?? Calendar.current.timeZone
    private var utcCalendar: Calendar
    
    private lazy var serverDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = self.utc
        formatter.dateFormat = YnabDateFormat.serverDate.rawValue
        return formatter
    }()
    
    private lazy var serverTimestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = self.utc
        formatter.dateFormat = YnabDateFormat.serverTimestamp.rawValue
        return formatter
    }()
    
    private init() {
        utcCalendar = Calendar(identifier: .gregorian)
        utcCalendar.timeZone = utc
    }
    
    func getFirstDayOfMonth(_ month: Int, year: Int? = nil) -> String? {
        let calendarYear = year ?? YnabCalendar.currentYear
        if let firstDay = utcCalendar.date(from: DateComponents(year: calendarYear, month: month, day: 1)) {
            return serverDateFormatter.string(from: firstDay)
        }
        return nil
    }
    
    func getDateComponent(from date: String, component: Calendar.Component, with format: YnabDateFormat) -> Int? {
        switch format {
        case .serverDate:
            if let date = serverDateFormatter.date(from: date) { return utcCalendar.component(component, from: date) }
        case .serverTimestamp:
            if let date = serverTimestampFormatter.date(from: date) { return utcCalendar.component(component, from: date) }
        }
        return nil
    }
    
    func getTimestamp(_ date: Date = Date()) -> String {
        return serverTimestampFormatter.string(from: date)
    }
    
    func getDate(timestamp: String) -> Date? {
        return serverTimestampFormatter.date(from: timestamp)
    }
}
