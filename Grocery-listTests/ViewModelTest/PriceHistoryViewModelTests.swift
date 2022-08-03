//
//  PriceHistoryViewModelTests.swift
//  Grocery-listTests
//
//  Created by Dongjie Zhang on 7/15/22.
//

import XCTest
import SwiftDate

@testable import Grocery_list

class PriceHistoryViewModelTests: XCTestCase {
    
    var sut: PriceHistoryViewModel!
    var mockRealmServices: MockRealmServices!
    
    override func setUp() {
        super.setUp()
        let testShopItem = ShopItem(name: "TestShopItem")
        
        let testShopRecords: [ShopRecord] = [
            DateInRegion("2021-12-01", region: .current),
            DateInRegion("2022-05-01", region: .current),
            DateInRegion("2022-06-01", region: .current),
            DateInRegion("2022-06-02", region: .current),
            DateInRegion("2022-07-01", region: .current)
        ].compactMap { date in
            guard let date = date else { return nil }
            let testShopRecord = ShopRecord()
            testShopRecord.date = date.date
            return testShopRecord
        }
        mockRealmServices = MockRealmServices(testName: name)
        try! mockRealmServices.realm.write {
            mockRealmServices.realm.add(testShopItem)
            testShopItem.shopRecords.append(objectsIn: testShopRecords)
        }
        
        sut = PriceHistoryViewModel(shopItem: testShopItem,
                                    themeColor: nil,
                                    realmServices: mockRealmServices)
    }
    
    override func tearDown() {
        sut = nil
        mockRealmServices = nil
        super.tearDown()
    }
    
    func test_init_withRecords_shouldGroupRecordsByMonnth() {
        for group in sut.recordGroups {
            print(group.year, group.month)
            for record in group.records {
                print(record.date)
            }
        }
        XCTAssertEqual(sut.recordGroups.count, 4)
        XCTAssertEqual(sut.recordGroups[0].year, 2022)
        XCTAssertEqual(sut.recordGroups[0].month, 7)
        XCTAssertEqual(sut.recordGroups[0].records.count, 1)
        XCTAssertEqual(sut.recordGroups[1].records.count, 2)
        XCTAssertEqual(sut.recordGroups[3].year, 2021)
    }
    
    func test_deleteShopRecord_withShopRecord_shouldDeleteInputShopRecord() {
        let testRecord = mockRealmServices.realm.objects(ShopRecord.self).first!
        
        let expectation = expectation(description: "DeleteShopRecord")
        sut.delete(record: testRecord) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        
        var isContains = false
        sut.recordGroups.forEach { group in
            isContains = group.records.contains(testRecord)
        }
        
        XCTAssertFalse(isContains)
    }
}
