//
//  ShopItemDetailViewModel.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/30/22.
//

import UIKit
import RealmSwift
import Combine

final class ShopItemDetailViewModel {
    
    var nameItemDetail: ShopItemDetailName
    @Published var cardItemDetails = [ShopItemDetailCard]()
    @Published var historyItemDetail: ShopItemDetailHistory!
    @Published var themeColor: UIColor?
    
    @Published var shopItem: ShopItem
    
    private let realmServices: RealmServices
    private var bindings = Set<AnyCancellable>()
    
    init(shopItem: ShopItem,
         themeColor: UIColor?,
         realmServices: RealmServices = LocalRealmServices()) {
        self.realmServices = realmServices
        self.shopItem = shopItem
        self.themeColor = themeColor
        self.nameItemDetail = ShopItemDetailName(type: .name, name: shopItem.name)
        
        setUpItemDetails()
    }
    
    func saveShopItem(name: String, onComplete: ((Error?) -> Void)? = nil) {
        guard name.count > 0,
              name != shopItem.name else { return }
        nameItemDetail = ShopItemDetailName(type: .name, name: shopItem.name)
        let shopItem = self.shopItem
        realmServices.writeAsync({ _ in
            shopItem.name = name
        }, onComplete: onComplete)
    }
    
    private func setUpItemDetails() {
        func onUpdate(_ newShopItem: ShopItem) {
            let itemsWithPrice = Array(newShopItem.shopRecords).filter{ $0.price != nil }
            
            historyItemDetail = ShopItemDetailHistory(type: .history,
                                                      itemCount: shopItem.shopRecords.count,
                                                      prices: itemsWithPrice.map{ $0.price! })
            
            cardItemDetails = [
                buildHistoryLowFrom(itemsWithPrice: itemsWithPrice),
                buildTotalCheckedFrom(items: Array(newShopItem.shopRecords)),
                buildAveragePriceFrom(itemsWithPrice: itemsWithPrice),
                buildFrequenceFrom(items: Array(newShopItem.shopRecords))
            ]
        }
        
        $shopItem
            .receive(on: RunLoop.main)
            .sink { item in
                onUpdate(item)
            }.store(in: &bindings)
    }
    
    private func buildHistoryLowFrom(itemsWithPrice: [ShopRecord]) -> ShopItemDetailCard {
        guard itemsWithPrice.count > 0 else {
            return ShopItemDetailCard(type: .historyLowPrice,
                                      value: "--",
                                      unit: "--")
        }
        let lowestPriceItem = itemsWithPrice.min{ $0.price! < $1.price! }!
        return ShopItemDetailCard(type: .historyLowPrice,
                                  value: LocalizedString.formatted(price: lowestPriceItem.price),
                                  unit: lowestPriceItem.date.formatted())
    }
    
    private func buildAveragePriceFrom(itemsWithPrice: [ShopRecord]) -> ShopItemDetailCard {
        guard itemsWithPrice.count > 0 else {
            return ShopItemDetailCard(type: .averagePrice,
                                      value: "--",
                                      unit: "--")
        }
        let sum = itemsWithPrice.reduce(Float(0)) { partialResult, record in
            return partialResult + record.price!
        }
        return ShopItemDetailCard(type: .averagePrice,
                                  value: LocalizedString.formatted(price: sum / Float(itemsWithPrice.count)),
                                  unit: "\(itemsWithPrice.count) \(LocalizedString.ItemDetail.timeUnit)")
    }
    
    private func buildTotalCheckedFrom(items: [ShopRecord]) -> ShopItemDetailCard {
        return ShopItemDetailCard(type: .totalCheckedCount,
                                  value: "\(shopItem.shopRecords.count)",
                                  unit: LocalizedString.ItemDetail.timeUnit)
    }
    
    private func buildFrequenceFrom(items: [ShopRecord]) -> ShopItemDetailCard {
        func defaultCard() -> ShopItemDetailCard{
            return ShopItemDetailCard(type: .checkedFrequence,
                                      value: "--",
                                      unit: "--")
        }
        guard items.count > 0 else {
            return defaultCard()
        }
        // add up gap between each checked item
        let sortedItems = items.sorted { $0.date < $1.date }
        var gaps = [TimeInterval]()
        for i in 0..<sortedItems.count - 1 {
            gaps.append(sortedItems[i + 1].date.timeIntervalSince(sortedItems[i].date))
        }
        guard gaps.count > 0 else {
            return defaultCard()
        }
        let averageGap = gaps.reduce(0, +) / Double(gaps.count)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day]
        formatter.unitsStyle = .full
        return ShopItemDetailCard(type: .checkedFrequence,
                                  value: formatter.string(from: averageGap)!,
                                  unit: LocalizedString.ItemDetail.frequenceUnit)
    }
}
