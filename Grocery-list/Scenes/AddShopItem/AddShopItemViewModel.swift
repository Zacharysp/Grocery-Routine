//
//  AddShopItemViewModel.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/15/22.
//

import Foundation
import UIKit

final class AddShopItemViewModel {
    
    @Published var shopItemName: String = ""
    @Published var themeColor: UIColor?
    @Published var itemGuesses = [ShopItemGuess]()
    
    private(set) lazy var isValid = $shopItemName
        .compactMap { $0.count > 0 }
        .eraseToAnyPublisher()
    
    private let shopList: ShopList
    
    private let realmServices: RealmServices
    
    init(shopList: ShopList, realmServices: RealmServices = LocalRealmServices()) {
        self.realmServices = realmServices
        self.shopList = shopList
        self.themeColor = UIColor(hex: shopList.theme)
    }
    
    func search(key: String) {
        let guesses = realmServices.realm.objects(ShopItemGuess.self)
        itemGuesses = guesses.where { $0.name.starts(with: key, options: .caseInsensitive) }.toArray()
    }
    
    func store(name: String? = nil, onComplete: ((Error?) -> Void)? = nil) {
        let newName = name ?? shopItemName
        guard newName.count > 0 else { return }
        // create new shop item
        let shopItem = ShopItem(name: newName)

        realmServices.writeAsync({ [weak self] realm in
            guard let self = self else { return }
            self.shopList.shopItems.append(shopItem)
            if self.checkNameGuessExist(name: newName) == false {
                // create new item guess
                 let itemGuess = ShopItemGuess()
                itemGuess.name = newName.capitalized
                realm.add(itemGuess)
            }
        }, onComplete: onComplete)
    }
    
    private func checkNameGuessExist(name: String) -> Bool {
        let guesses = realmServices.realm.objects(ShopItemGuess.self)
        return guesses.where { $0.name.equals(name) }.count > 0
    }
}
