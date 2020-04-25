//
//  SyncSummary.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 4/25/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

struct YearlySyncSummary: Codable {
    let year: Int
    let monthlyReports: [MonthlySyncReport]
    
    init(_ year: Int, monthlyStatuses: [MonthlySyncReport] = []) {
        self.year = year
        self.monthlyReports = monthlyStatuses
    }
    
    enum CodingKeys: String, CodingKey {
        case year = "year"
        case monthlyReports = "sync"
    }
}

struct MonthlySyncReport: Codable {
    let status: SyncStatus
    let month: Int
    let lastSyncTime: Date?
    
    init(_ month: Int, status: SyncStatus = .outOfDate, lastSyncTime: Date? = Date()) {
        self.status = status
        self.month = month
        self.lastSyncTime = lastSyncTime
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let statusInt = try values.decode(Int.self, forKey: .status)
        let timestamp = try values.decode(String?.self, forKey: .lastSyncTime)
        
        month = try values.decode(Int.self, forKey: .month)
        status = SyncStatus(rawValue: statusInt) ?? .outOfDate
        if let lastUpdated = timestamp, let lastUpdatedDate = YnabDateFormatter.shared.getDate(timestamp: lastUpdated) {
            lastSyncTime = lastUpdatedDate
        } else {
            lastSyncTime = nil
        }
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
