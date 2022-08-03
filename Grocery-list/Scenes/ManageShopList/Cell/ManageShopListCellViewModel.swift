//
//  ManageShopListCellViewModel.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/15/22.
//

import Foundation
import UIKit

final class ManageShopListCellViewModel {
    
    @Published var name: String = ""
    @Published var itemCount: Int = 0
    @Published var isSelected: Bool = false
    @Published var themeColor: UIColor?
    
    private let shopList: ShopList
    
    init(shopList: ShopList, isSelected: Bool) {
        self.shopList = shopList
        self.isSelected = isSelected
        setUpBindings()
    }
    
    private func setUpBindings() {
        name = shopList.name
        itemCount = shopList.shopItems.count
        themeColor = UIColor(hex: shopList.theme)
    }
}
