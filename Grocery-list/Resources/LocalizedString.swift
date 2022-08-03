//
//  LocalizedString.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/23/22.
//

import Foundation

struct LocalizedString {
    
    static let priceUnitFormat = "$ %.2f"
    
    static func formatted(price: Float?) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        let number = price ?? 0
        return formatter.string(from: number as NSNumber) ?? String(format: priceUnitFormat, number)
    }
    
    static let delete = "DELETE".localized()
    static let confirm = "CONFIRM".localized()
    
    // alert view
    static let confirmUndoItemTitle = "CONFIRM_UNDO_ITEM_TITLE".localized()
    static let confirmUndoItemMessage = "CONFIRM_UNDO_ITEM_MESSAGE".localized()
    
    static let confirmDeleteItemTitle = "CONFIRM_DELETE_ITEM_TITLE".localized()
    static let confirmDeleteItemMessage = "CONFIRM_DELETE_ITEM_MESSAGE".localized()
    
    static let confirmDeleteListTitle = "CONFIRM_DELETE_LIST_TITLE".localized()
    static let confirmDeleteListMessage = "CONFIRM_DELETE_LIST_MESSAGE".localized()
    
    
    static let confirmRecordTitle = "CONFIRM_RECORD_TITLE".localized()
    static let confirmRecordMessage = "CONFIRM_RECORD_MESSAGE".localized()
    
    // form items
    static let themeColor = "THEME_COLOR".localized()
    
    // item details
    struct ItemDetail {
        static let historyLowPrice = "HISTORY_LOW_PRICE".localized()
        static let averagePrice = "AVERAGE_PRICE".localized()
        static let totalCheckedCount = "TOTAL_CHECKED_COUNT".localized()
        static let checkedFrequence = "CHECKED_FREQUENCE".localized()
        static let trends = "TRENDS".localized()
        static let storeName = "STORE_NAME".localized()
        static let viewAll = "VIEW_ALL".localized()
        static let storeDetail = "STORE_DETAIL".localized()
        static let timeUnit = "TIME_UNIT".localized()
        static let frequenceUnit = "FREQUENCE_UNIT".localized()
        static let noData = "NO_DATA".localized()
    }
    
    struct PriceHistory {
        static let noHistory = "NO_HISTORY".localized()
    }
    
    struct AddPrice {
        static let noCameraAccess = "NO_CAMERA_ACCESS".localized()
        static let goToSetting = "GO_TO_SETTING".localized()
        static let cameraGuide = "CAMERA_GUIDE".localized()
    }
    
    struct ManageShopList {
        static let newNamePlaceHolder = "NEW_NAME_PLACEHOLDER".localized()
        static let itemUnitSingle = "ITEM_UNIT_SINGLE".localized()
        static let itemUnitPlural = "ITEM_UNIT_PLURAL".localized()
        static let title = "MY_SHOP_LIST".localized()
    }
    
    struct AddShopItem {
        static let itemName = "ITEM_NAME".localized()
        static let itemPlaceholder = "ITEM_PLACEHOLDER".localized()
        static let addItem = "ADD_ITEM".localized()
    }
    
    struct ShopListDetail {
        static let storeName = "STORE_NAME".localized()
        static let storeDetail = "STORE_DETAIL".localized()
    }
    
    struct MainList {
        static let lastBuy = "LAST_BUY".localized()
    }
    
    struct ShopList {
        static let defaultName = "DEFAULT_NAME".localized()
    }
}
