//
//  AddShopItemViewModelTests.swift
//  Grocery-listTests
//
//  Created by Dongjie Zhang on 7/15/22.
//

import XCTest
import Combine

@testable import Grocery_list

class AddShopItemViewModelTests: XCTestCase {
    var sut: AddShopItemViewModel!
    var mockRealmServices: MockRealmServices!
    
    override func setUp() {
        super.setUp()
        let testShopList = ShopList(name: "TestShopList")
        mockRealmServices = MockRealmServices(testName: name)
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(testShopList)
        }
        
        sut = AddShopItemViewModel(shopList: testShopList,
                                   realmServices: mockRealmServices)
    }
    
    override func tearDown() {
        sut = nil
        mockRealmServices = nil
        super.tearDown()
    }
    
    private func preloadItemGuess() {
        let guesses = [
            "hot sauce",
            "hotdog buns",
            "hummus",
            "ice cream",
            "ice-cream",
            "icing",
            "instant potatoes",
            "jam",
            "jelly",
            "juice",
            "juice concentrate",
            "ketchup",
            "kidney",
            "kiwis",
            "lasagna",
            "lemon juice",
            "lemons",
            "lentils",
            "lettuce",
            "lime juice",
            "limes",
            "lip balm",
            "lobster",
            "lotion",
            "malt"
        ]
        let shopItemGuesses: [ShopItemGuess] = guesses.map { name in
            let guess = ShopItemGuess()
            guess.name = name.capitalized
            return guess
        }
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(shopItemGuesses)
        }
    }
    
    func test_store_withNewShopItemName_shouldCreateNewShopItemAndStore() {
        let newName = "TestShopItem"
        
        let expectation = expectation(description: "StoreNewShopItem")
        sut.store(name: newName) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        let localShopList = mockRealmServices.realm.objects(ShopList.self).first
        XCTAssertEqual(localShopList?.shopItems.first?.name, newName)
    }
    
    func test_store_withNoInputName_shouldCreateNewShopItemAndStore() {
        let newName = "TestShopItem"
        sut.shopItemName = newName
        
        let expectation = expectation(description: "StoreNewShopItem")
        sut.store() { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        let localShopList = mockRealmServices.realm.objects(ShopList.self).first
        XCTAssertEqual(localShopList?.shopItems.first?.name, newName)
    }
    
    func test_store_withNewShopItemName_shouldAlsoCreateNewShopItemGuessWithSameName() {
        let newName = "Testshopitem"
        
        let expectation = expectation(description: "StoreNewShopItem")
        sut.store(name: newName) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        let localShopItemGuess = mockRealmServices.realm.objects(ShopItemGuess.self).first
        XCTAssertEqual(localShopItemGuess?.name, newName)
    }
    
    func test_store_withNewShopItemNameAndThisNameGuessIsAlreayExist_shouldNotCreateNewShopItemGuess() {
        let newName = "Testshopitem"
        let shopItemGuess = ShopItemGuess()
        shopItemGuess.name = newName
        // add preset shop item guess to realm
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(shopItemGuess)
        }
        
        let expectation = expectation(description: "StoreNewShopItem")
        sut.store(name: newName) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        let localShopItemGuesses = mockRealmServices.realm.objects(ShopItemGuess.self)
        XCTAssertEqual(localShopItemGuesses.count, 1)
    }
    
    func test_searchItemGuess_withInputKey_shouldReturnRelatedItemGuess() {
        preloadItemGuess()
        
        let searchKey = "le"
        
        sut.search(key: searchKey)
        
        XCTAssertEqual(sut.itemGuesses.count, 4)
        let itemGuessNames = sut.itemGuesses.map { $0.name }
        XCTAssertEqual(itemGuessNames, ["Lemon Juice",
                                        "Lemons",
                                        "Lentils",
                                        "Lettuce"])
    }
}
