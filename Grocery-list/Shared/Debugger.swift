//
//  Debugger.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/19/22.
//

import Foundation
import OSLog

struct Debugger {
    static let logger: Logger = {
        return Logger(
            subsystem: "com.theqiyu.Grocery-list",
            category: "RealmDatabase"
        )
    }()
    
    static func log(_ items: Any..., filename: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        print("📗[\((filename as NSString).lastPathComponent):\(line)] \(function) ===> ")
        print(items)
        #endif
    }
    static func warning(_ items: Any..., filename: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        print("📙[\((filename as NSString).lastPathComponent):\(line)] \(function) ===> ")
        print(items)
        #endif
    }
    static func fatal(_ items: Any..., filename: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        print("📕[\((filename as NSString).lastPathComponent):\(line)] \(function) ===> ")
        print(items)
        #endif
    }
}
