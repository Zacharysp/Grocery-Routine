//
//  ManageShopListViewModel.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/15/22.
//

import Foundation
import UIKit

final class ManageShopListViewModel {
    
    @Published var shopLists: [ShopList]
    @Published var currentIndex: Int
    @Published var themeColor: UIColor?
    
    private let realmServices: RealmServices
    
    init(shopLists: [ShopList],
         currentIndex: Int = 0,
         realmServices: RealmServices = LocalRealmServices()) {
        self.realmServices = realmServices
        self.shopLists = shopLists
        self.currentIndex = currentIndex
        if currentIndex < shopLists.count {
            themeColor = UIColor(hex: shopLists[currentIndex].theme)
        }
    }
    
    func createNewShopList() {
        // check if all current shopList already has name
        for shopList in shopLists {
            if shopList.name == "" {
                // cannot create new shoplist while the creation of last shoplist is not finished.
                return
            }
        }
        let newShopList = ShopList(name: "")
        shopLists.append(newShopList)
    }
    
    func storeShopList(name: String, index: Int, onComplete: ((Error?) -> Void)? = nil) {
        guard index < shopLists.count else { return }
        let shopList = shopLists[index]
        realmServices.writeAsync({ realm in
            shopList.name = name
            realm.add(shopList)
        }, onComplete: onComplete)
    }
}
