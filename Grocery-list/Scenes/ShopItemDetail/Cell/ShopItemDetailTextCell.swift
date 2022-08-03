//
//  ShopItemDetailTextCell.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/3/22.
//

import UIKit

final class ShopItemDetailTextCell: UICollectionViewCell {
    
    static let id = "ShopItemDetailTextCellId"
    
    lazy var nameTextField: TextFieldFormItemView = {
        let image = UIImage(systemName: "highlighter")!
        let textField = TextFieldFormItemView(title: LocalizedString.ItemDetail.storeName,
                                              image: image,
                                              displayWordCount: true)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addViews()
    }
    
    func setTheme(color: UIColor?) {
        nameTextField.set(color: color)
    }
    
    private func addViews() {
        contentView.subviews(nameTextField)
        nameTextField.followEdges(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
