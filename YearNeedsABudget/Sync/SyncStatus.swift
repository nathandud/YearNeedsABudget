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
    case outOfDate = 2
    case inProgress = 1
}

enum SyncRequestType {
    case thisMonth
    case lastTwoMonths
    case lastThreeMonths
    case lastSixMonths
    case fullCalendarYear
}

struct SyncProgressYear: Codable {
    let year: Int
    let syncProgressMonths: [SyncProgressMonth]
    
    init(year: Int, syncProgressMonths: [SyncProgressMonth] = []) {
        self.year = year
        self.syncProgressMonths = syncProgressMonths
    }
    
    enum CodingKeys: String, CodingKey {
        case year = "year"
        case syncProgressMonths = "sync_progress"
    }
}

struct SyncProgressMonth: Codable {
    let status: SyncStatus
    let month: Int
    let lastSyncTime: Date?
    
    init(month: Int, status: SyncStatus = .outOfDate, lastSyncTime: Date? = nil) {
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
