//
//  AddPriceViewModel.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/17/22.
//

import Foundation
import Vision
import UIKit

final class AddPriceViewModel {
    
    @Published var name: String? = ""
    @Published var recognizedPrice: Float = 0
    @Published var userPrice: Float? // user type in
    @Published var themeColor: UIColor?
    
    private let shopItem: ShopItem
    
    init(shopItem: ShopItem, themeColor: UIColor?) {
        self.shopItem = shopItem
        name = shopItem.name
        self.themeColor = themeColor
    }
    
    func markCheckedWith(price: Float) {
        shopItem.checkItem(price: price)
    }
    
    func numberDetectHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation],
              error == nil else {
            return
        }
        
        var recognizedString: String = ""
        
        // sort observations by their detected rectangle size.
        // we only focus on the large font text as a price.
        let sizeSortedObservation = observations.sorted{ $0.size() > $1.size() }
        var index = 0
        
        // loop all observations until we hit the assembled recognized string contains "."
        while recognizedString.contains(".") == false, index < sizeSortedObservation.count {
            defer { index += 1 }
            
            let observation = sizeSortedObservation[index]
            // remove non numeric chars from string. ex. "$"
            guard let price = observation.topCandidates(1).first?.string.filter("0123456789.".contains) else {
                continue
            }
            
            // normally the price tage always comes with format "00.00"
            // if the recognized string doesn't has ".", we will look to the next largest text for the decimal position.
            if recognizedString.count == 0 {
                recognizedString = price
            } else {
                recognizedString = "\(recognizedString).\(price)"
            }
        }
        
        if let priceInFloat = Float(recognizedString),
           priceInFloat < 100000 { // only use price under 100000
            recognizedPrice = priceInFloat
        }
    }
}
