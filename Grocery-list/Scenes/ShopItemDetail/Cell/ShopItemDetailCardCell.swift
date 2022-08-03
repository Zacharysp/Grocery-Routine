//
//  ShopItemDetailCardCell.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/3/22.
//

import UIKit
import Stevia

final class ShopItemDetailCardCell: UICollectionViewCell {
    
    static let id = "ShopItemDetailCardCellId"
    
    var itemDetail: ShopItemDetailCard? {
        didSet {
            guard let itemDetail = itemDetail else {
                return
            }
            titleLabel.text = itemDetail.type.title()
            valueLabel.text = itemDetail.value
            unitLabel.text = itemDetail.unit
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
            valueImageView.image = UIImage(systemName: itemDetail.type.imageName(), withConfiguration: config)
        }
    }
    
    private lazy var titleLabel = UILabel()
    private lazy var valueLabel = UILabel()
    private lazy var unitLabel = UILabel()
    private lazy var valueImageView = UIImageView()
    private lazy var container = UIView()
    private lazy var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addViews()
        setUpViews()
    }
    
    func setTheme(color: UIColor?) {
        valueImageView.tintColor = color
    }
    
    private func addViews() {
        contentView.subviews(
            titleLabel,
            container.subviews(stackView)
        )
        
        titleLabel
            .top(2)
            .fillHorizontally(padding: 2)
            .height(20)
        
        container
            .fillHorizontally(padding: 2)
            .bottom(2)
        container.Top == titleLabel.Bottom + 2
        
        stackView
            .fillHorizontally(padding: .gap)
            .fillVertically(padding: .gap)
    }
    
    private func setUpViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryText
        
        container.backgroundColor = .gray.withAlphaComponent(0.2)
        container.layer.cornerRadius = .cornerRadius
        container.layer.masksToBounds = true
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = .gap
        
        let imageContainer = UIView()
        imageContainer.subviews(valueImageView)
        valueImageView.left(0).fillVertically()
        stackView.addArrangedSubview(imageContainer)
        
        valueLabel.font = UIFont.systemFont(ofSize: 20)
        valueLabel.textAlignment = .center
        stackView.addArrangedSubview(valueLabel)
        
        unitLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        unitLabel.textAlignment = .right
        unitLabel.textColor = .secondaryText
        stackView.addArrangedSubview(unitLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
