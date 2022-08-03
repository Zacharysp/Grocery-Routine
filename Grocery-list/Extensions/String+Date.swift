//
//  String+Date.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/30/22.
//

import Foundation
import SwiftDate

extension String {
    func toDate() -> Date? {
        return DateInRegion(self, region: Region.current)?.date
    }
}
