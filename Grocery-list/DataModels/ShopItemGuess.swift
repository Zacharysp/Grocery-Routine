//
//  ShopItemGuess.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/28/22.
//

import RealmSwift

final class ShopItemGuess: Object {
    @Persisted var name: String = ""
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? ShopItemGuess else { return false }
        return self.name == object.name
    }
}
