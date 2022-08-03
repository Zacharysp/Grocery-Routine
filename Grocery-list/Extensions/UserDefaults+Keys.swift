//
//  UserDefaults+Keys.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/14/22.
//

import Foundation

extension UserDefaults {
    
    enum Keys: String, CaseIterable {
        case currentShopList
        case isPriceTrackingOn
        case loadPresetItemGuess
    }
    
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
    
    func didLoadPresetItemGuess() -> Bool {
        return bool(forKey: Keys.loadPresetItemGuess.rawValue)
    }
    
    func finishLoadPresetItemGuess() {
        set(true, forKey: Keys.loadPresetItemGuess.rawValue)
    }
    
    func currentShopListId() -> String? {
        return string(forKey: Keys.currentShopList.rawValue)
    }
    
    func set(currrentShopList: ShopList?) {
        guard let id = currrentShopList?._id.stringValue else { return }
        set(id, forKey: Keys.currentShopList.rawValue)
    }
}
