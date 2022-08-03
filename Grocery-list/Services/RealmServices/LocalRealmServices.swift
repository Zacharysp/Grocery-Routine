//
//  RealmServices.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/14/22.
//

import Foundation
import RealmSwift

final class LocalRealmServices: RealmServices {
    
    var realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            Debugger.logger.error("Cannot open default realm file \(error.localizedDescription, privacy: .public)")
            fatalError("Cannot open realm")
        }
    }
    
    func writeAsync(_ block: @escaping (_ realm: Realm) -> Void, onComplete: ((Error?) -> Void)? = nil) {
        realm.writeAsync({
            block(self.realm)
        }, onComplete: onComplete)
    }
    
    func loadItemGuess() {
        guard UserDefaults.standard.didLoadPresetItemGuess() == false else { return }
        guard let path = Bundle.main.path(forResource: "ShopItemGuesses", ofType: "plist"),
              let root = NSDictionary(contentsOfFile: path) else {
            Debugger.logger.warning("Cannot open shop item guess plist")
            return
        }
        guard let guesses = root["Guesses"] as? [String] else {
            // cannot open guesses
            Debugger.logger.warning("Cannot find shop item guess array")
            return
        }
    
        let shopItemGuesses: [ShopItemGuess] = guesses.map { name in
            let guess = ShopItemGuess()
            guess.name = name.capitalized
            return guess
        }
        
        realm.writeAsync({
            self.realm.add(shopItemGuesses)
            Debugger.log("Shop item guess loaded.")
        }, onComplete: { error in
            guard error == nil else {
                Debugger.logger.fault("Cannot store item guess to realm")
                return
            }
            UserDefaults.standard.finishLoadPresetItemGuess()
        })
    }
}
