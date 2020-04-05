//
//  SyncStatus.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/25/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

enum SyncStatus: Int {
    case upToDate = 0
    case inProgress = 1
    case outOfDate = 2
}

struct YearlySyncSummary: Codable {
    let year: Int
    let monthlyStatuses: [MonthSyncStatus]
    
    init(_ year: Int, monthlyStatuses: [MonthSyncStatus] = []) {
        self.year = year
        self.monthlyStatuses = monthlyStatuses
    }
    
    enum CodingKeys: String, CodingKey {
        case year = "year"
        case monthlyStatuses = "sync_progress"
    }
}

struct MonthSyncStatus: Codable {
    let status: SyncStatus
    let month: Int
    let lastSyncTime: Date?
    
    init(_ month: Int, status: SyncStatus = .outOfDate, lastSyncTime: Date? = nil) {
        self.status = status
        self.month = month
        self.lastSyncTime = lastSyncTime
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let statusInt = try values.decode(Int.self, forKey: .status)
        let timestamp = try values.decode(String.self, forKey: .lastSyncTime)
        month = try values.decode(Int.self, forKey: .month)
        status = SyncStatus(rawValue: statusInt) ?? .outOfDate
        lastSyncTime = YnabDateFormatter.shared.getDate(timestamp: timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let statusInt = status.rawValue
        var timestamp: String? = nil
        if let sync = lastSyncTime { timestamp = YnabDateFormatter.shared.getTimestamp(sync) }
        
        try container.encode(statusInt, forKey: .status)
        try container.encode(timestamp, forKey: .lastSyncTime)
        try container.encode(month, forKey: .month)
    }
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case month = "month"
        case lastSyncTime = "last_sync_time"
    }
}

enum SyncRequestType {
    case thisMonth
    case lastTwoMonths
    case lastThreeMonths
    case lastSixMonths
    case fullCalendarYear
}


