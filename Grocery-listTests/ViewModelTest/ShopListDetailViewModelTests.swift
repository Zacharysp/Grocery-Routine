//
//  ShopListDetailViewModelTests.swift
//  Grocery-listTests
//
//  Created by Dongjie Zhang on 7/14/22.
//

import XCTest
import Combine

@testable import Grocery_list

class ShopListDetailViewModelTests: XCTestCase {
    
    var sut: ShopListDetailViewModel!
    var mockRealmServices: MockRealmServices!
    
    override func setUp() {
        super.setUp()
        let testShopList = ShopList(name: "TestShopList")
        mockRealmServices = MockRealmServices(testName: name)
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(testShopList)
        }
        
        sut = ShopListDetailViewModel(shopList: testShopList, realmServices: mockRealmServices)
    }
    
    override func tearDown() {
        sut = nil
        mockRealmServices = nil
        super.tearDown()
    }
    
    func test_saveShopListName_withName_ShouldUpdateShopListName() {
        let newName = "TestShopListNewName"
        
        let expectation = expectation(description: "saveShopListName")
        sut.saveShopList(name: newName) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(sut.shopListName, newName)
        XCTAssertEqual(sut.shopList.name, newName)
    }
    
    func test_saveShopListColor_withColor_ShouldUpdateShopListColor() {
        let newColorHex = "#E76F52"
        let newColor = UIColor(hex: newColorHex)
        
        let expectation = expectation(description: "saveShopListColor")
        sut.save(newColor: newColor) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(sut.themeColor, newColor)
        XCTAssertEqual(sut.shopList.theme, newColorHex)
    }
}
