//
//  AddShopItemView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/15/22.
//

import UIKit
import Stevia

final class AddShopItemView: UIView {
    
    lazy var nameTextField: TextFieldFormItemView = {
        let image = UIImage(systemName: "highlighter")!
        let textField = TextFieldFormItemView(title: LocalizedString.AddShopItem.itemName,
                                              image: image,
                                              placeholder: LocalizedString.AddShopItem.itemPlaceholder,
                                              displayWordCount: true)
        return textField
    }()
    
    lazy var backButton = UIButton()
    lazy var saveButton = UIButton()
    lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: ItemTagViewLayout())
    }()
    
    private lazy var topContainer = UIView()
    private lazy var titleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        addViews()
        setUpViews()
    }
    
    func setTheme(color: UIColor?) {
        backButton.tintColor = color
        nameTextField.set(color: color)
        saveButton.tintColor = color
    }
    
    private func addViews() {
        subviews(
            topContainer.subviews(
                titleLabel,
                backButton,
                saveButton
            ),
            nameTextField,
            collectionView
        )
        
        topContainer
            .fillHorizontally()
            .height(50)
        topContainer.Top == self.safeAreaLayoutGuide.Top + .margin
        
        backButton
            .left(.gap)
            .centerVertically()
            .size(26)
        
        saveButton
            .right(.gap)
            .centerVertically()
            .size(26)
        
        titleLabel
            .fillVertically()
            .fillHorizontally(padding: .margin)
        
        nameTextField.fillHorizontally(padding: .margin)
        nameTextField.Top == topContainer.Bottom + .gap
        
        collectionView
            .fillHorizontally(padding: .margin)
            .bottom(.margin)
        collectionView.Top == nameTextField.Bottom + .gap
    }
    
    private func setUpViews() {
        backgroundColor = .background
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        backButton.setImage(UIImage(systemName: "arrow.left",
                                     withConfiguration: config),
                             for: .normal)
        
        titleLabel.text = LocalizedString.AddShopItem.addItem
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        
        saveButton.setImage(UIImage(systemName: "plus",
                                    withConfiguration: config),
                            for: .normal)
        saveButton.isHidden = true
        
        collectionView.backgroundColor = .clear
        collectionView.register(ItemGuessCell.self, forCellWithReuseIdentifier: ItemGuessCell.id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
