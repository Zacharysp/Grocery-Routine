//
//  PriceHistoryCell.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/21/22.
//

import UIKit
import Stevia
import Combine

final class PriceHistoryCell: UITableViewCell {
    static let id = "PriceHistoryCellId"

    lazy var priceLabel = UILabel()
    lazy var dateLabel = UILabel()
    lazy var deleteButton = UIButton()
    
    var viewModel: PriceHistroyCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    private lazy var container = UIView()
    private lazy var priceImage = UIImageView()
    private var bindings = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: PriceHistoryCell.id)
        
        addViews()
        setUpViews()
        
        selectionStyle = .none
    }
    
    func setTheme(color: UIColor?) {
        priceImage.tintColor = color
        deleteButton.tintColor = color
    }
    
    private func addViews() {
        subviews(
            container.subviews(
                priceImage,
                priceLabel,
                dateLabel
            ),
            deleteButton
        )
        
        container
            .left(.gap)
            .fillVertically(padding: 4)
            .height(40)
        
        priceImage
            .left(.margin)
            .size(16)
            .width(16)
            .centerVertically()
        
        priceLabel.centerVertically()
        priceLabel.Left == priceImage.Right + 2
        
        dateLabel
            .right(.margin)
            .centerVertically()
        dateLabel.Left == priceLabel.Right + .gap
        
        deleteButton
            .right(.gap)
            .centerVertically()
            .size(36)
        deleteButton.Left == container.Right + .gap
    }
    
    private func setUpViews() {
        backgroundColor = .clear
        
        container.backgroundColor = .gray.withAlphaComponent(0.2)
        container.layer.cornerRadius = .cornerRadius
        container.clipsToBounds = true
        
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .light, scale: .small)
        priceImage.image = UIImage(systemName: "tag.fill", withConfiguration: config)
        
        priceLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        dateLabel.textAlignment = .right
        
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
    }
    
    private func setUpViewModel() {
        priceLabel.text = viewModel.price
        dateLabel.text = viewModel.date
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

