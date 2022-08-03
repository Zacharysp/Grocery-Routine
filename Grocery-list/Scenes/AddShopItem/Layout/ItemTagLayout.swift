//
//  ItemTagLayout.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/28/22.
//

import UIKit

fileprivate class Row {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }

    func tagLayout(collectionViewWidth: CGFloat) {
        var offset = 0
        for attribute in attributes {
            attribute.frame.origin.x = CGFloat(offset)
            offset += Int(attribute.frame.width + spacing)
        }
    }
}

final class ItemTagViewLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var rows = [Row]()
        var currentRowY: CGFloat = -1

        for attribute in attributes {
            if currentRowY != attribute.frame.origin.y {
                currentRowY = attribute.frame.origin.y
                rows.append(Row(spacing: 10))
            }
            // copy to new instance to avoid mismatch cached frame warning.
            let attributeCopy = attribute.copy() as! UICollectionViewLayoutAttributes
            rows.last?.add(attribute: attributeCopy)
        }

        rows.forEach {
            $0.tagLayout(collectionViewWidth: collectionView?.frame.width ?? 0)
        }
        return rows.flatMap { $0.attributes }
    }
}
