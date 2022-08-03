//
//  MainListViewModelTests.swift
//  Grocery-listTests
//
//  Created by Dongjie Zhang on 6/29/22.
//

import XCTest
import Combine

@testable import Grocery_list

class MainListViewModelTests: XCTestCase {
    
    var sut: MainListViewModel!
    var mockRealmServices: MockRealmServices!
    
    private var bindings = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockRealmServices = MockRealmServices(testName: name)
        sut = MainListViewModel(realmServices: mockRealmServices)
        UserDefaults.standard.reset()
    }
    
    override func tearDown() {
        sut = nil
        mockRealmServices = nil
        UserDefaults.standard.reset()
        bindings.removeAll()
        super.tearDown()
    }
    
    func test_fetchShopList_withNoInput_firstTimeShouldReadDefaultShopList() {
        let defaultShopListName = ShopList.defaultShopList.name
        
        let expectation = expectation(description: "fetchShopList")
        var fetchedCurrentShopList: ShopList?
        
        sut.$currentShopList
            .compactMap{ $0 }
            .sink { shopList in
                fetchedCurrentShopList = shopList
                expectation.fulfill()
            }.store(in: &bindings)
        
        sut.fetchShopList()

        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(fetchedCurrentShopList!.name, defaultShopListName)
    }
    
    func test_fetchShopList_withLocalShopList_shouldReadLocalShopList() {
        let shopListName = "TestShopList"
        let shopList = ShopList(name: shopListName)
        
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(shopList)
        }
        
        let expectation = expectation(description: "fetchShopList")
        var fetchedCurrentShopList: ShopList?

        sut.$currentShopList
            .compactMap{ $0 }
            .sink { shopList in
                fetchedCurrentShopList = shopList
                expectation.fulfill()
            }.store(in: &bindings)
        
        sut.fetchShopList()

        waitForExpectations(timeout: 10)

        XCTAssertEqual(fetchedCurrentShopList!.name, shopListName)
    }
    
    func test_fetchShopList_withNoCurrentShopList_shouldSetFirstAsCurrentShopList() {
        let shopList = ShopList(name: "TestShopList")
        
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(shopList)
        }
        
        let expectation = expectation(description: "fetchShopList")

        sut.$currentShopList
            .compactMap{ $0 }
            .sink { shopList in
                expectation.fulfill()
            }.store(in: &bindings)

        sut.fetchShopList()

        waitForExpectations(timeout: 10)

        let currentShopListId = UserDefaults.standard.currentShopListId()

        XCTAssertEqual(currentShopListId, shopList._id.stringValue)
    }
    
    func test_fetchShopList_withPresetCurrentShopList_shouldReadCurrentShopList() {
        
        var shopLists = [
            ShopList(name: "TestShopList1"),
            ShopList(name: "TestShopList2")
        ]
        
        let currentShopListId = shopLists.last!._id.stringValue
        UserDefaults.standard.set(currrentShopList: shopLists.last!)
        
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(shopLists)
        }
        
        shopLists = []
        
        let expectation = expectation(description: "fetchShopList")
        var fetchedCurrentShopList: ShopList?
        
        sut.$currentShopList
            .compactMap{ $0 }
            .sink { shopList in 
                fetchedCurrentShopList = shopList
                expectation.fulfill()
            }.store(in: &bindings)
        
        sut.fetchShopList()

        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(currentShopListId, fetchedCurrentShopList!._id.stringValue)
    }
    
    func test_deleteShopList_withShopList_shouldDeleteInputShopList() {
        let shopList = ShopList(name: "TestShopList")
        
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(shopList)
        }
        
        let expectation = expectation(description: "deleteShopList")
        
        sut.shopLists = [shopList]
        sut.delete(shopList: shopList) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        
        let localShopList = mockRealmServices.realm.objects(ShopList.self)
        XCTAssertEqual(localShopList.count, 0)
        
    }
    
    func test_deleteShopItem_withShopItem_shouldDeleteInputShopItem() {
        let shopItem = ShopItem(name: "TestShopItem")
        let shopList = ShopList(name: "TestShopList")
        
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(shopList)
            shopList.shopItems.append(shopItem)
        }
        
        let expectation = expectation(description: "deleteShopItem")
        
        sut.shopItems = [shopItem]
        sut.delete(shopItem: shopItem) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(sut.shopItems.count, 0)
        let localShopItem = mockRealmServices.realm.objects(ShopItem.self)
        XCTAssertEqual(localShopItem.count, 0)
    }
    
    func test_swithToShopList_withShopList_shouldSetCurrentShopListAndOther() {
        let localShopListId = UserDefaults.standard.currentShopListId()
        XCTAssertNil(localShopListId)
        XCTAssertNil(sut.themeColor)
        XCTAssertNil(sut.currentShopList)
        XCTAssertEqual(sut.shopItems.count, 0)
        
        let shopList = ShopList(name: "TestShopList")
        
        sut.switchTo(shopList: shopList)
        
        XCTAssertEqual(sut.themeColor, UIColor(hex: shopList.theme))
        XCTAssertEqual(sut.currentShopList, shopList)
        XCTAssertEqual(UserDefaults.standard.currentShopListId(), shopList._id.stringValue)
        XCTAssertEqual(sut.shopItems.count, shopList.shopItems.count)
    }
}


