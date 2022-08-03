//
//  ShopList.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/12/22.
//

import Foundation
import RealmSwift
import UIKit

fileprivate func presetColor() -> String {
    let hexs = [
        "#2a9d8f",
        "#e9c46a",
        "#f4a261",
        "#e76f51",
        "#e63946",
        "#a8dadc",
        "#457b9d",
        "#cb997e",
        "#bdb2ff",
        "#ffadad",
        "#7209b7"
    ]
    return hexs[Int.random(in: 0..<hexs.count)]
}

final class ShopList: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var theme: String = ""
    @Persisted var shopItems: List<ShopItem>
    
    convenience init(name: String, theme: String = "") {
        self.init()
        self.name = name
        self.theme = presetColor()
    }
    
    static let defaultShopList = ShopList(name: LocalizedString.ShopList.defaultName)
}
