//
//  MainListCellViewModel.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/12/22.
//

import Foundation
import Combine
import SwiftDate
import UIKit

final class MainListCellViewModel {
    
    @Published var name: String = ""
    @Published var price: String = "--"
    @Published var lastBuy: String = "\(LocalizedString.MainList.lastBuy): --"
    @Published var isChecked = false
    
    private let item: ShopItem
    
    init(item: ShopItem) {
        self.item = item
        setUpBindings()
    }
    
    func needsToUpdateWith(price: Float?) {
        if isChecked {
            presentUnCheckAlert()
        } else {
            item.checkItem(price: price)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
    private func presentUnCheckAlert() {
        let themeColor = UIColor(hex: item.shopList.first!.theme)
        let confirmButton = AlertButton(color: themeColor)
        confirmButton.addTarget(self, action: #selector(unCheckConfirmed), for: .touchUpInside)
        let presentAlertView = AlertView(title: LocalizedString.confirmUndoItemTitle,
                                         subtitle: LocalizedString.confirmUndoItemMessage,
                                         buttons: [confirmButton],
                                         themeColor: themeColor)
        let presenter = AlertPresenter(presentView: presentAlertView)
        presenter.present()
    }
    
    @objc private func unCheckConfirmed() {
        item.unCheckItem()
    }
    
    private func setUpBindings() {
        name = item.name
        isChecked = item.isChecked()
        if let lowestPrice = item.lowestPrice {
            price = LocalizedString.formatted(price: lowestPrice)
        }
        
        if let lastBuyDate = item.lastBuyDate {
            lastBuy = "\(LocalizedString.MainList.lastBuy): \(lastBuyDate.toRelative(style: RelativeFormatter.defaultStyle(), locale: Locales.current))"
        }
    }
}

