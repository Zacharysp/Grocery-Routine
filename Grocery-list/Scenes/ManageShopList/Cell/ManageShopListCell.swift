//
//  ManageShopListCell.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/15/22.
//

import UIKit
import Stevia

final class ManageShopListCell: UITableViewCell {
    static let id = "ManageShopListCellId"
    
    var viewModel: ManageShopListCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    lazy var nameTextfield = UITextField()
    lazy var countLabel = UILabel()
    
    private lazy var container = UIView()
    private lazy var selectionImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: ManageShopListCell.id)
        
        addViews()
        setUpViews()
        
        selectionStyle = .none
    }
    
    private func addViews() {
        subviews(
            container.subviews(
                selectionImageView,
                nameTextfield,
                countLabel
            )
        )
        
        container
            .fillVertically(padding: 2)
            .fillHorizontally(padding: .gap)
            .height(46)
        
        selectionImageView
            .left(.margin)
            .centerVertically()
        
        nameTextfield.fillVertically()
        nameTextfield.Left == selectionImageView.Right + .gap
        
        countLabel
            .right(.margin)
            .fillVertically()
        countLabel.Left >= nameTextfield.Right + .gap
    }
    
    private func setUpViews() {
        backgroundColor = .clear
        
        container.backgroundColor = .gray.withAlphaComponent(0.2)
        container.layer.cornerRadius = .cornerRadius
        container.clipsToBounds = true
        
        nameTextfield.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameTextfield.placeholder = LocalizedString.ManageShopList.newNamePlaceHolder
        nameTextfield.returnKeyType = .done
        nameTextfield.delegate = self
        
        countLabel.font = UIFont.systemFont(ofSize: 12)
        countLabel.textAlignment = .right
    }
    
    private func setUpViewModel() {
        nameTextfield.text = viewModel.name
        // for new shoplist item, allow user enter name
        if viewModel.name.count == 0 {
            nameTextfield.isUserInteractionEnabled = true
            nameTextfield.becomeFirstResponder()
        } else {
            nameTextfield.isUserInteractionEnabled = false
        }
        
        let itemUnit = viewModel.itemCount > 1 ?
        LocalizedString.ManageShopList.itemUnitPlural : LocalizedString.ManageShopList.itemUnitSingle
        countLabel.text = "\(viewModel.itemCount) \(itemUnit)"
        
        let imageName = viewModel.isSelected ? "circle.inset.filled" : "circle"
        selectionImageView.image = UIImage(systemName: imageName)
        selectionImageView.tintColor = viewModel.themeColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ManageShopListCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
