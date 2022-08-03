//
//  ShopListDetailViewModel.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/14/22.
//

import Foundation
import UIKit

final class ShopListDetailViewModel {
    
    @Published var themeColor: UIColor?
    
    var shopListName: String
    let shopList: ShopList
    
    private let realmServices: RealmServices
    
    init(shopList: ShopList, realmServices: RealmServices = LocalRealmServices()) {
        self.realmServices = realmServices
        self.shopList = shopList
        self.shopListName = shopList.name
        self.themeColor = UIColor(hex: shopList.theme)
    }
    
    func saveShopList(name: String, onComplete: ((Error?) -> Void)? = nil) {
        guard name.count > 0,
              name != shopList.name else { return }
        shopListName = name
        let shopList = self.shopList
        realmServices.writeAsync({ _ in
            shopList.name = name
        }, onComplete: onComplete)
    }
    
    func save(newColor: UIColor, onComplete: ((Error?) -> Void)? = nil) {
        themeColor = newColor
        let shopList = self.shopList
        realmServices.writeAsync({ _ in
            shopList.theme = newColor.hexString()
        }, onComplete: onComplete)
    }
}
