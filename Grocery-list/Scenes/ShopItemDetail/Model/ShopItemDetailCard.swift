//
//  ShopItemDetailCard.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/5/22.
//

import Foundation

struct ShopItemDetailCard: ShopItemDetail {
    
    let type: ShopItemDetailType
    let value: String
    let unit: String
    
    init(type: ShopItemDetailType,
         value: String,
         unit: String) {
        self.type = type
        self.value = value
        self.unit = unit
    }
    
    static func == (lhs: ShopItemDetailCard, rhs: ShopItemDetailCard) -> Bool {
        return lhs.type == rhs.type && lhs.value == rhs.value && lhs.unit == rhs.unit
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(value)
        hasher.combine(unit)
    }
}
