//
//  ShopItemDetailHistory.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/5/22.
//

import Foundation

struct ShopItemDetailHistory: ShopItemDetail {
    
    let type: ShopItemDetailType
    let itemCount: Int
    let prices: [Float]
    
    init(type: ShopItemDetailType, itemCount: Int, prices: [Float]) {
        self.type = type
        self.itemCount = itemCount
        self.prices = prices
    }
    
    static func == (lhs: ShopItemDetailHistory, rhs: ShopItemDetailHistory) -> Bool {
        return lhs.prices == rhs.prices
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(prices)
    }
}
