//
//  MainListCell.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/12/22.
//

import UIKit
import Stevia
import Combine
import CombineCocoa

final class MainListCell: UITableViewCell {
    static let id = "MainListCellId"
    
    var viewModel: MainListCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    lazy var nameLabel = UILabel()
    lazy var checkBox = CheckBox()
    lazy var priceLabel = UILabel()
    lazy var lastBuyLabel = UILabel()
    lazy var detailButton = UIButton()
    var theme: UIColor = .primary
    
    private lazy var container = UIView()
    private lazy var priceImage = UIImageView()
    private var bindings = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MainListCell.id)
        
        addViews()
        setUpViews()
        setUpBindings()
        
        selectionStyle = .none
    }
    
    func setTheme(color: UIColor?) {
        checkBox.tintColor = color
        priceImage.tintColor = color
        detailButton.tintColor = color
    }
    
    private func addViews() {
        subviews(
            container.subviews(
                nameLabel,
                priceImage,
                priceLabel,
                lastBuyLabel,
                detailButton,
                checkBox
            )
        )
        
        container.fillVertically(padding: 2)
        container.fillHorizontally(padding: .gap)
        
        checkBox
            .left(.gap)
            .centerVertically()
            .height(40)
        checkBox.Width == checkBox.Height
        
        nameLabel.top(.gap)
        nameLabel.Left == checkBox.Right + .gap
        nameLabel.Right == detailButton.Left - .gap
        
        priceImage
            .size(16)
            .width(16)
            .bottom(.gap)
        priceImage.Top == nameLabel.Bottom + .gap
        priceImage.Left == nameLabel.Left
        
        priceLabel.Top == priceImage.Top
        priceLabel.Bottom == priceLabel.Bottom
        priceLabel.Left == priceImage.Right + 2
        
        lastBuyLabel.Top == priceImage.Top
        lastBuyLabel.Bottom == priceLabel.Bottom
        lastBuyLabel.Right == detailButton.Left - .gap
        lastBuyLabel.Left == priceLabel.Right + .gap
        
        detailButton
            .right(.gap)
            .centerVertically()
            .size(26)
    }
    
    private func setUpViews() {
        backgroundColor = .clear
        
        container.backgroundColor = .gray.withAlphaComponent(0.2)
        container.layer.cornerRadius = .cornerRadius
        container.clipsToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameLabel.numberOfLines = 0
        
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .light, scale: .small)
        priceImage.image = UIImage(systemName: "tag.fill", withConfiguration: config)
        priceImage.tintColor = theme
        
        priceLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        lastBuyLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        lastBuyLabel.textAlignment = .right
        
        detailButton.setImage(UIImage(systemName: "slider.horizontal.3"),
                              for: .normal)
        detailButton.tintColor = theme
    }
    
    private func setUpViewModel() {
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        lastBuyLabel.text = viewModel.lastBuy
        checkBox.isChecked = viewModel.isChecked
        setIfNeedsDimmed()
    }
    
    private func setIfNeedsDimmed() {
        nameLabel.textColor = viewModel.isChecked ? .gray : .text
        priceLabel.textColor = viewModel.isChecked ? .gray : .text
        lastBuyLabel.textColor = viewModel.isChecked ? .gray : .text
    }
    
    private func setUpBindings() {
        checkBox.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.viewModel.needsToUpdateWith(price: nil)
            }.store(in: &bindings)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

