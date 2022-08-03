//
//  MockRealmService.swift
//  Grocery-listTests
//
//  Created by Dongjie Zhang on 6/29/22.
//

import Foundation
import RealmSwift

@testable import Grocery_list

final class MockRealmServices: RealmServices {
    var realm: Realm
    
    init(testName: String) {
        do {
            realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: testName))
        } catch {
            Debugger.fatal(error)
            fatalError("Test cannot open realm")
        }
    }
    
    func writeAsync(_ block: @escaping (_ realm: Realm) -> Void, onComplete: ((Error?) -> Void)? = nil) {
        realm.writeAsync({
            block(self.realm)
        }, onComplete: onComplete)
    }
}
