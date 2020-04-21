//
//  Logging.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/18/20.
//  Many thanks to https://www.avanderlee.com/debugging/oslog-unified-logging/
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "YearNeedsABudget"

    static let networking = OSLog(subsystem: subsystem, category: "networking")
    static let viewCycle = OSLog(subsystem: subsystem, category: "viewcycle")
    static let repository = OSLog(subsystem: subsystem, category: "repository")
    static let filesystem = OSLog(subsystem: subsystem, category: "filesystem")
}
