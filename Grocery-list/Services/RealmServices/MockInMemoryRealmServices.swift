//
//  MockInMemoryRealmServices.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/30/22.
//

import Foundation
import RealmSwift
import SwiftDate

typealias MockingData = [String: [(price: Float?, dateString: String)]]

let mockingDataUS: MockingData = [
    "Organic Caesar Salad": [
        (10.02, "2022-07-30 12:25:49"),
        (10.02, "2022-07-28 15:30:09"),
        (10.02, "2022-07-21 11:39:03"),
        (8.02, "2022-07-13 18:10:17"),
        (10.02, "2022-07-02 14:26:30")
    ],
    "Coke Zero": [
        (12.29, "2022-07-28 15:30:09"),
        (nil, "2022-07-21 11:39:03"),
        (14.29, "2022-07-13 18:10:17"),
        (12.29, "2022-07-02 14:26:30"),
        (16.72, "2022-06-22 14:57:12")
    ],
    "Smoked Salmon": [
        (19.99, "2022-07-28 15:30:09"),
        (24.56, "2022-07-21 11:39:03"),
        (20.56, "2022-07-13 18:10:17"),
        (24.56, "2022-07-02 14:26:30")
    ],
    "Spindrift Sparkling Water": [
        (nil, "2022-08-01 00:05:49"),
        (nil, "2022-07-13 18:10:17")
    ],
    "Pasture Raised Egg": [
        (6.99, "2022-07-28 15:30:09"),
        (8.79, "2022-07-21 11:39:03"),
        (8.79, "2022-07-13 18:10:17"),
    ],
    "Spring Mix": [
        (4.49, "2022-08-01 00:05:49"),
        (4.49, "2022-07-28 15:30:09"),
        (4.49, "2022-07-21 11:39:03"),
        (nil, "2022-07-13 18:10:17"),
    ],
    "Banana": [
        (1.79, "2022-07-30 00:05:49"),
        (1.59, "2022-07-28 15:30:09"),
        (1.79, "2022-07-21 11:39:03"),
        (nil, "2022-07-13 18:10:17"),
    ]
]

let mockingDataCN: MockingData = [
    "农化巨峰葡萄": [
        (8.39, "2022-07-30 12:25:49"),
        (8.39, "2022-07-28 15:30:09"),
        (9.80, "2022-07-21 11:39:03"),
        (9.80, "2022-07-13 18:10:17"),
        (9.80, "2022-07-02 14:26:30")
    ],
    "原味拉面": [
        (11.20, "2022-07-28 15:30:09"),
        (13.00, "2022-07-21 11:39:03"),
        (13.00, "2022-07-13 18:10:17"),
        (13.00, "2022-07-02 14:26:30"),
        (13.00, "2022-06-22 14:57:12")
    ],
    "屈臣氏苏打水": [
        (16.90, "2022-07-28 15:30:09"),
        (16.90, "2022-07-21 11:39:03"),
        (16.40, "2022-07-13 18:10:17"),
        (16.40, "2022-07-02 14:26:30")
    ],
    "红豆沙雪糕": [
        (nil, "2022-08-01 09:25:49"),
        (nil, "2022-07-13 18:10:17")
    ],
    "西红柿": [
        (4.29, "2022-08-01 09:25:49"),
        (4.29, "2022-07-28 15:30:09"),
        (4.29, "2022-07-21 11:39:03"),
        (3.68, "2022-07-13 18:10:17"),
    ],
    "奥尔良鸡翅": [
        (21.50, "2022-07-30 12:25:49"),
        (20.90, "2022-07-28 15:30:09"),
        (20.90, "2022-07-21 11:39:03"),
        (nil, "2022-07-13 18:10:17"),
    ],
    "椰树椰汁": [
        (4.90, "2022-07-30 12:25:49"),
        (4.00, "2022-07-28 15:30:09"),
        (4.90, "2022-07-21 11:39:03"),
        (nil, "2022-07-13 18:10:17"),
    ]
]

final class MockInMemoryRealmServices: RealmServices {
    var realm: Realm
    
    init() {
        do {
            realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MockImMemoryRealmServices"))
        } catch {
            Debugger.fatal(error)
            fatalError("Cannot open in-memory realm")
        }
    }
    
    func writeAsync(_ block: @escaping (_ realm: Realm) -> Void, onComplete: ((Error?) -> Void)? = nil) {
        realm.writeAsync({
            block(self.realm)
        }, onComplete: onComplete)
    }
    
    func loadPreset(mockingData: MockingData) {
        let shopItems: [ShopItem] = mockingData.keys.sorted().map { key in
            return buildShopItem(name: key, data: mockingData[key]!)
        }
        
        let shopList = ShopList(name: "Costco")
        shopList.shopItems.append(objectsIn: shopItems)
        shopList.theme = "#e63946"
        
        realm.writeAsync {
            self.realm.add(shopList)
        }
    }
    
    private func buildShopItem(name: String, data: [(price: Float?, dateString: String)]) -> ShopItem {
        let shopRecords: [ShopRecord] = data.map { record in
            let shopRecord = ShopRecord(price: record.price)
            shopRecord.date = record.dateString.toDate()!.date
            return shopRecord
        }.sorted { $0.date < $1.date }
        
        let item = ShopItem(name: name)
        item.lastBuyDate = data.first!.dateString.toDate()!.date
        item.lowestPrice = data.first!.price
        item.shopRecords.append(objectsIn: shopRecords)
        return item
    }
}
