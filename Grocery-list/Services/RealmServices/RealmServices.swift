//
//  RealmServices.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/29/22.
//

import Foundation
import RealmSwift

protocol RealmServices {
    var realm: Realm { set get }
    func writeAsync(_ block: @escaping (_ realm: Realm) -> Void, onComplete: ((Error?) -> Void)?)
}

extension RealmServices {
    func writeAsync(_ block: @escaping (_ realm: Realm) -> Void, onComplete: ((Error?) -> Void)? = nil) {
        writeAsync(block, onComplete: onComplete)
    }
}
