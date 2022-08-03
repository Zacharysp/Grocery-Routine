//
//  ShopItem.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/12/22.
//

import Foundation
import RealmSwift
import UIKit
import SwiftDate

final class ShopItem: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var addedDate = Date()
    @Persisted var lastBuyDate: Date?
    @Persisted var lowestPrice: Float?
    @Persisted var shopRecords: List<ShopRecord>
    
    @Persisted(originProperty: "shopItems") var shopList: LinkingObjects<ShopList>

    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    func isChecked() -> Bool {
        guard let lastBuyDate = lastBuyDate else { return false }
        return  DateInRegion(lastBuyDate, region: Region(zone: TimeZone.current)).isToday
    }
    
    func findLowestPrice() -> Float? {
        return shopRecords.min { lhs, rhs in
            return lhs.price ?? Float.greatestFiniteMagnitude < rhs.price ?? Float.greatestFiniteMagnitude
        }?.price
    }
    
    func checkItem(price: Float?) {
        LocalRealmServices().writeAsync{ _ in
            self.lastBuyDate = Date()
            self.shopRecords.append(ShopRecord(price: price))
            self.lowestPrice = self.findLowestPrice()
        }
    }
    
    func unCheckItem() {
        LocalRealmServices().writeAsync{ realm in
            if let lastRecord = self.shopRecords.last {
                realm.delete(lastRecord)
            }
            self.lastBuyDate = self.shopRecords.last?.date
            self.lowestPrice = self.findLowestPrice()
        }
    }
    
    func delete(record: ShopRecord, comletion: ((Error?) -> Void)? = nil) {
        guard shopRecords.contains(record) else { return }
        LocalRealmServices().writeAsync({ realm in
            realm.delete(record)
            self.lastBuyDate = self.shopRecords.last?.date
            self.lowestPrice = self.findLowestPrice()
        }, onComplete: comletion)
    }
}
