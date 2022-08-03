//
//  PriceHistoryViewModel.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/21/22.
//

import Foundation
import RealmSwift
import SwiftDate
import UIKit

final class PriceHistoryViewModel {
    
    var itemName: String
    @Published var recordGroups = [ShopRecordGroup]() // group by month
    @Published var themeColor: UIColor?
    
    private let shopItem: ShopItem
    
    private let realmServices: RealmServices
    
    init(shopItem: ShopItem,
         themeColor: UIColor?,
         realmServices: RealmServices = LocalRealmServices()) {
        self.realmServices = realmServices
        self.shopItem = shopItem
        self.itemName = shopItem.name
        recordGroups = group(records: Array(shopItem.shopRecords))
        self.themeColor = themeColor
    }
    
    func delete(record: ShopRecord, onComplete: ((Error?) -> Void)? = nil) {
        for (groupIndex, group) in recordGroups.enumerated() {
            guard let first = group.records.first,
            isSameGroupOf(lhs: first, rhs: record),
            let recordIndex = group.records.firstIndex(of: record) else { continue }
            recordGroups[groupIndex].records.remove(at: recordIndex)
            if recordGroups[groupIndex].records.count == 0 {
                recordGroups.remove(at: groupIndex)
            }
            break
        }
        
        realmServices.writeAsync({ realm in
            realm.delete(record)
            self.shopItem.lastBuyDate = self.shopItem.shopRecords.last?.date
            self.shopItem.lowestPrice = self.shopItem.findLowestPrice()
        }, onComplete: onComplete)
    }
    
    private func group(records: [ShopRecord]) -> [ShopRecordGroup] {
        var monthSection = [ShopRecord]()
        var result = [ShopRecordGroup]()
        
        func appendSectionToGroup() {
            guard let firstRecord = monthSection.first else { return }
            let dateInRegion = DateInRegion(firstRecord.date, region: Region.current)
            result.append(ShopRecordGroup(month: dateInRegion.month,
                                          year: dateInRegion.year,
                                          records: monthSection))
        }
        
        for record in records.sorted(by: { $0.date > $1.date}) {
            guard let first = monthSection.first else {
                // nothing in month section, fill this record in.
                monthSection.append(record)
                continue
            }
            
            if isSameGroupOf(lhs: first, rhs: record) {
                monthSection.append(record)
            } else {
                // append current month group to result
                appendSectionToGroup()
                // clean month section for new month.
                monthSection.removeAll()
                monthSection.append(record)
            }
        }
        // append last section to group
        appendSectionToGroup()
        return result
    }
    
    private func isSameGroupOf(lhs: ShopRecord, rhs: ShopRecord) -> Bool {
        // compare two record's date, if they have the same month and year.
        let lhsDate = DateInRegion(lhs.date, region: Region.current)
        let rhsDate = DateInRegion(rhs.date, region: Region.current)
        return lhsDate.month == rhsDate.month && lhsDate.year == rhsDate.year
    }
}
