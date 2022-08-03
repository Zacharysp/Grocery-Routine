//
//  PriceHistroyCellViewModel.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/21/22.
//

import Foundation
import Combine

final class PriceHistroyCellViewModel {
    @Published var price: String = "--"
    @Published var date: String = ""
    
    private let record: ShopRecord
    
    init(record: ShopRecord) {
        self.record = record
        setUpBindings()
    }
    
    private func setUpBindings() {
        if let recordPrice = record.price {
            price = LocalizedString.formatted(price: recordPrice)
        }
        
        date = record.date.formatted()
    }
}
