//
//  RealmResults+Array.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/14/22.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Element] {
        return self.compactMap { $0 }
    }
}
