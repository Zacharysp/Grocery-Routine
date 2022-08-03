//
//  ShopItemDetailViewModelTests.swift
//  Grocery-listTests
//
//  Created by Dongjie Zhang on 7/22/22.
//

import XCTest
import SwiftDate

@testable import Grocery_list

class ShopItemDetailViewModelTests: XCTestCase {
    
    var mockRealmServices: MockRealmServices!
    
    override func setUp() {
        super.setUp()
        mockRealmServices = MockRealmServices(testName: name)
    }
    
    override func tearDown() {
        mockRealmServices = nil
        super.tearDown()
    }
    
    func test_init_withShopItem_shouldBuildHistoryLowPriceCard() {
        let prices: [Float] = [1.2, 2.1, 1.8, 1.8]
        let historyLowPrice = prices.min()!
        let testShopRecords: [ShopRecord] = prices.map { price in
            return ShopRecord(price: price)
        }
        let testShopItem = ShopItem(name: "TestShopItem")
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(testShopItem)
            testShopItem.shopRecords.append(objectsIn: testShopRecords)
        }
        
        let sut = ShopItemDetailViewModel(shopItem: testShopItem,
                                          themeColor: nil,
                                          realmServices: mockRealmServices)
        let lowestCard = sut.cardItemDetails.first!
        XCTAssertEqual(lowestCard.type, .historyLowPrice)
        XCTAssertEqual(lowestCard.value, LocalizedString.formatted(price: historyLowPrice))
    }
    
    func test_init_withShopItem_shouldBuildTotalCheckedCard() {
        let count = 10
        let testShopRecords: [ShopRecord] = (0..<count).map { price in
            return ShopRecord()
        }
        let testShopItem = ShopItem(name: "TestShopItem")
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(testShopItem)
            testShopItem.shopRecords.append(objectsIn: testShopRecords)
        }
        let sut = ShopItemDetailViewModel(shopItem: testShopItem,
                                          themeColor: nil,
                                          realmServices: mockRealmServices)
        let totalCheckedCard = sut.cardItemDetails[1]
        XCTAssertEqual(totalCheckedCard.type, .totalCheckedCount)
        XCTAssertEqual(totalCheckedCard.value, "\(count)")
    }
    
    func test_init_withShopItem_shouldBuildAveragePriceCard() {
        let prices: [Float] = [1.2, 2.1, 1.8, 1.8]
        let averagePrice = prices.reduce(0, +) / Float(prices.count)
        let testShopRecords: [ShopRecord] = prices.map { price in
            return ShopRecord(price: price)
        }
        let testShopItem = ShopItem(name: "TestShopItem")
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(testShopItem)
            testShopItem.shopRecords.append(objectsIn: testShopRecords)
        }
        let sut = ShopItemDetailViewModel(shopItem: testShopItem,
                                          themeColor: nil,
                                          realmServices: mockRealmServices)
        let averageCard = sut.cardItemDetails[2]
        XCTAssertEqual(averageCard.type, .averagePrice)
        XCTAssertEqual(averageCard.value, LocalizedString.formatted(price: averagePrice))
    }
    
    func test_init_withShopItem_shouldBuildCheckedFrequenceCard() {
        // build dates with given gap array.
        let startDate = DateInRegion("2022-06-01", region: .current)
        let gaps = [1, 2, 1, 4, 5]
        var dates = [startDate]
        for gap in gaps {
            dates.append(dates.last!?.dateByAdding(gap, .day))
        }
        
        let testShopRecords: [ShopRecord] = dates.compactMap { date in
            guard let date = date else { return nil }
            let testShopRecord = ShopRecord()
            testShopRecord.date = date.date
            return testShopRecord
        }
        let testShopItem = ShopItem(name: "TestShopItem")
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(testShopItem)
            testShopItem.shopRecords.append(objectsIn: testShopRecords)
        }
        
        let sut = ShopItemDetailViewModel(shopItem: testShopItem,
                                          themeColor: nil,
                                          realmServices: mockRealmServices)
        let frequenceCard = sut.cardItemDetails[3]
        
        let averageGapInDays = Double(gaps.reduce(0, +)) / Double(gaps.count)
        let averageGapInTimeInterval = averageGapInDays * 24 * 60 * 60
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day]
        formatter.unitsStyle = .full
        let frequenceString =  formatter.string(from: averageGapInTimeInterval)!
        
        XCTAssertEqual(frequenceCard.type, .checkedFrequence)
        XCTAssertEqual(frequenceCard.value, frequenceString)
    }
    
    
    func test_init_withShopItem_shouldBuildPriceHistory() {
        let shopRecordsWithPrice = [
            ShopRecord(price: 1.2),
            ShopRecord(price: 2.2),
            ShopRecord(price: 1.4),
            ShopRecord(price: 1.2),
        ]
        let shopRecordWithoutPrice = [ShopRecord(), ShopRecord()]
        let testShopItem = ShopItem(name: "TestShopItem")
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(testShopItem)
            testShopItem.shopRecords.append(objectsIn: shopRecordsWithPrice + shopRecordWithoutPrice)
        }
        
        let sut = ShopItemDetailViewModel(shopItem: testShopItem,
                                          themeColor: nil,
                                          realmServices: mockRealmServices)
        
        XCTAssertEqual(sut.historyItemDetail.itemCount, shopRecordsWithPrice.count + shopRecordWithoutPrice.count)
        XCTAssertEqual(sut.historyItemDetail.prices.count, shopRecordsWithPrice.count)
    }
    
    func test_saveShopItemName_withNewName_shouldUpdateShopItemName() {
        let testShopItem = ShopItem(name: "TestShopItem")
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(testShopItem)
        }
        let sut = ShopItemDetailViewModel(shopItem: testShopItem,
                                          themeColor: nil,
                                          realmServices: mockRealmServices)
        let newName = "NewTestShopItem"
        
        let expectation = expectation(description: "SaveShopItemName")
        sut.saveShopItem(name: newName) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(testShopItem.name, newName)
    }
}
