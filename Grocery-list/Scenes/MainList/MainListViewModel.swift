//
//  MainListViewModel.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/11/22.
//

import Foundation
import Combine
import RealmSwift
import UIKit

final class MainListViewModel{
    
    @Published var currentShopList: ShopList?
    @Published var shopItems = [ShopItem]()
    @Published var themeColor: UIColor?
    
    var shopLists = [ShopList]()
    private var bindings = Set<AnyCancellable>()
    
    private let realmServices: RealmServices
    
    init(realmServices: RealmServices = LocalRealmServices()) {
        self.realmServices = realmServices
    }
    
    func currentSelectedIndex() -> Int {
        guard let current = currentShopList else { return 0 }
        return shopLists.firstIndex(of: current) ?? 0
    }
    
    func delete(shopItem: ShopItem, onComplete: ((Error?) -> Void)? = nil) {
        guard let index = shopItems.firstIndex(of: shopItem) else { return }
        shopItems.remove(at: index)
        realmServices.writeAsync({ realm in
            realm.delete(shopItem.shopRecords)
            realm.delete(shopItem)
        }, onComplete: onComplete)
    }
    
    func delete(shopList: ShopList, onComplete: ((Error?) -> Void)? = nil) {
        guard let index = shopLists.firstIndex(of: shopList) else { return }
        shopLists.remove(at: index)
        if currentShopList == shopList {
            switchTo(shopList: shopLists.first ?? defaultShopList())
        }
        realmServices.writeAsync({ realm in
            for item in shopList.shopItems {
                realm.delete(item.shopRecords)
            }
            realm.delete(shopList.shopItems)
            realm.delete(shopList)
        }, onComplete: onComplete)
    }
    
    func switchTo(shopList: ShopList) {
        currentShopList = shopList
        themeColor = UIColor(hex: shopList.theme)
        shopItems = Array(shopList.shopItems)
        UserDefaults.standard.set(currrentShopList: shopList)
    }
    
    func fetchShopList() {
        let valueHandler: (Results<ShopList>) -> Void = { [weak self] list in
            guard let self = self else { return }
            var shopLists = list.toArray()
            
            if shopLists.count == 0 {
                // create default shop list
                shopLists.append(self.defaultShopList())
            }
            self.shopLists = shopLists
            self.setUpCurrentShopList()
        }
        
        realmServices.realm.objects(ShopList.self)
            .collectionPublisher
            .sink(receiveCompletion: { _ in }, receiveValue: valueHandler)
            .store(in: &bindings)
    }
    
    private func defaultShopList() -> ShopList {
        let defaultShopList = ShopList.defaultShopList
        realmServices.writeAsync { realm in
            realm.add(defaultShopList)
        }
        return defaultShopList
    }
    
    private func setUpCurrentShopList() {
        if let currentShopListId = UserDefaults.standard.currentShopListId() {
            for shopList in shopLists {
                if shopList._id.stringValue == currentShopListId {
                    switchTo(shopList: shopList)
                    return
                }
            }
        }
        // no current shop list found
        // set the first one as current
        if let shopList = shopLists.first {
            switchTo(shopList: shopList)
        }
    }
}
