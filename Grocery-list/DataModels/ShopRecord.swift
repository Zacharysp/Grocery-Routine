//
//  ShopRecord.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/11/22.
//

import Foundation
import RealmSwift

final class ShopRecord: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var price: Float?
    @Persisted var date = Date()
    
    @Persisted(originProperty: "shopRecords") var shopItem: LinkingObjects<ShopItem>
    
    convenience init(price: Float? = nil) {
        self.init()
        self.price = price
    }
}
