//
//  YnabMoney.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 4/30/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

struct YnabMoney {
    static func getCurrencyString(serverAmount: Int) -> String? {
        let amount = Double(abs(serverAmount)) / 1000.0
        return YnabNumberFormatter.shared.getCurrency(from: amount)
    }
}

fileprivate class YnabNumberFormatter {
    
    static let shared = YnabNumberFormatter()
    
    private lazy var currencyFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    private init() {}
    
    func getCurrency(from amount: Double) -> String? {
        return currencyFormat.string(from: NSNumber(value: amount))
    }
}
