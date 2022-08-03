//
//  String+Localized.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/23/22.
//

import Foundation

extension String {    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
