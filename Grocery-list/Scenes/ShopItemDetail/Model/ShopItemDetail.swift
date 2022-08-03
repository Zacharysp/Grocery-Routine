//
//  ShopItemDetail.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/3/22.
//

import Foundation

enum ShopItemDetailType: CaseIterable {
    case name
    case historyLowPrice
    case averagePrice
    case totalCheckedCount
    case checkedFrequence
    case history
    
    func title() -> String {
        switch self {
        case .name:
            return ""
        case .historyLowPrice:
            return LocalizedString.ItemDetail.historyLowPrice
        case .averagePrice:
            return LocalizedString.ItemDetail.averagePrice
        case .totalCheckedCount:
            return LocalizedString.ItemDetail.totalCheckedCount
        case .checkedFrequence:
            return LocalizedString.ItemDetail.checkedFrequence
        case .history:
            return LocalizedString.ItemDetail.trends
        }
    }
    
    func imageName() -> String {
        switch self {
        case .name, .history:
            return ""
        case .historyLowPrice:
            return "tag.fill"
        case .averagePrice:
            return "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right"
        case .totalCheckedCount:
            return "checkmark.circle.fill"
        case .checkedFrequence:
            return "f.cursive.circle.fill"
        }
    }
}

protocol ShopItemDetail: Hashable {
    var type: ShopItemDetailType { get }
}

