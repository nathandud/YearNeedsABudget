//
//  ObservationProtocols.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/24/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation

protocol Observer {
    var uuid: UUID { get }
}

protocol Observerable {
    func addObserver(observer: Observer, closure: @escaping (Bool) -> Void)
    func removeObserver(observer: Observer)
}


