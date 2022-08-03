//
//  ManageShopListViewModelTests.swift
//  Grocery-listTests
//
//  Created by Dongjie Zhang on 7/15/22.
//

import XCTest
import Combine

@testable import Grocery_list

class ManageShopListViewModelTests: XCTestCase {
    var sut: ManageShopListViewModel!
    var mockRealmServices: MockRealmServices!
    
    override func setUp() {
        super.setUp()
        mockRealmServices = MockRealmServices(testName: name)
        sut = ManageShopListViewModel(shopLists: [], realmServices: mockRealmServices)
    }
    
    override func tearDown() {
        sut = nil
        mockRealmServices = nil
        super.tearDown()
    }
    
    func test_createNewShopList_withNoInput_shouldCreateNewShopListWithNoName() {
        sut.createNewShopList()
        
        XCTAssertEqual(sut.shopLists.count, 1)
        let newShopList = sut.shopLists.first
        XCTAssertEqual(newShopList!.name, "")
    }
    
    func test_createNewShopList_alreadyHasNewShopListWithNoName_shouldDoNothing() {
        let preloadShopList = ShopList(name: "")
        sut.shopLists.append(preloadShopList)
        
        sut.createNewShopList()
        
        XCTAssertEqual(sut.shopLists.count, 1)
    }
    
    func test_storeShopList_withNoInput_shouldStoreShopListWithName() {
        let shopList = ShopList(name: "")
        sut.shopLists.append(shopList)
        
        let newName = "TestShopList"
        let index = 0
        let expectation = expectation(description: "storeShopList")
        sut.storeShopList(name: newName,
                          index: index) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(sut.shopLists[index].name, newName)
        let storedShopList = mockRealmServices.realm.objects(ShopList.self).first
        XCTAssertEqual(storedShopList?.name, newName)
    }
}
