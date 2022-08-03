//
//  ShopListDetailView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/14/22.
//

import UIKit
import Stevia

final class ShopListDetailView: UIView {
    
    lazy var nameTextField: TextFieldFormItemView = {
        let image = UIImage(systemName: "highlighter")!
        let textField = TextFieldFormItemView(title: LocalizedString.ShopListDetail.storeName,
                                              image: image,
                                              displayWordCount: true)
        return textField
    }()
    lazy var themeColorView = ColorPickerItemView()
    lazy var deleteButton = UIButton()
    lazy var backButton = UIButton()
    
    private lazy var stackView = UIStackView()
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
        themeColorView.update(color: color)
    }
    
    private func addViews() {
        subviews(
            topContainer.subviews(
                titleLabel,
                backButton
            ),
            stackView,
            deleteButton
        )
        
        topContainer
            .fillHorizontally()
            .height(50)
        topContainer.Top == self.safeAreaLayoutGuide.Top + .margin
        
        backButton
            .left(.margin)
            .centerVertically()
            .size(26)
        
        titleLabel
            .fillVertically()
            .fillHorizontally(padding: .margin)
        
        deleteButton
            .height(40)
            .fillHorizontally(padding: .margin)
        deleteButton.Bottom == safeAreaLayoutGuide.Bottom - .margin
        
        stackView.fillHorizontally(padding: .margin)
        stackView.Top == topContainer.Bottom + .gap
        stackView.Bottom <= deleteButton.Top - .gap
    }
    
    private func setUpViews() {
        backgroundColor = .background
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        backButton.setImage(UIImage(systemName: "arrow.left",
                                     withConfiguration: config),
                             for: .normal)
        
        titleLabel.text = LocalizedString.ShopListDetail.storeDetail
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = .gap
        
        deleteButton.setTitle(LocalizedString.delete, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        deleteButton.layer.cornerRadius = .cornerRadius
        deleteButton.layer.masksToBounds = true
        deleteButton.backgroundColor = .red
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(themeColorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
