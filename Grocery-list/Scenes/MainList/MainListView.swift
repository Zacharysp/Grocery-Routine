//
//  MainListView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/11/22.
//

import UIKit
import Stevia

final class MainListView: UIView {
    
    lazy var topContainer = UIView()
    lazy var storeNameLabel = UILabel()
    lazy var listView = UITableView()
    lazy var storeEditButton = UIButton()
    lazy var manageStoreButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        addViews()
        setUpViews()
    }
    
    func setTheme(color: UIColor?) {
        manageStoreButton.tintColor = color
        storeEditButton.tintColor = color
        if let footer = listView.footerView(forSection: 0) as? TableViewActionFooterView {
            footer.setTheme(color: color)
        }
    }
    
    func switchTo(list: ShopList) {
        storeNameLabel.text = list.name
    }
    
    private func addViews() {
        subviews(
            topContainer.subviews(
                manageStoreButton,
                storeNameLabel,
                storeEditButton
            ),
            listView
        )
        
        topContainer.fillHorizontally()
        topContainer.Top == self.safeAreaLayoutGuide.Top
        topContainer.height(50)
        
        manageStoreButton
            .left(.margin)
            .size(30)
        manageStoreButton.CenterY == storeNameLabel.CenterY
        
        storeNameLabel
            .bottom(.gap)
        storeNameLabel.Left == manageStoreButton.Right + .gap
        
        storeEditButton
            .size(30)
            .right(.margin)
        storeEditButton.Left == storeNameLabel.Right + 2
        storeEditButton.Bottom == storeNameLabel.Bottom - 2
        storeEditButton.CenterY == storeNameLabel.CenterY
        
        listView.fillHorizontally()
        listView.Top == topContainer.Bottom + .gap
        listView.Bottom == self.safeAreaLayoutGuide.Bottom
    }
    
    private func setUpViews() {
        backgroundColor = .background
        
        manageStoreButton.setImage(UIImage(systemName: "square.stack.3d.up.fill"), for: .normal)
        
        storeNameLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        storeNameLabel.textAlignment = .left
        
        storeEditButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        
        listView.register(MainListCell.self, forCellReuseIdentifier: MainListCell.id)
        listView.register(TableViewActionFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewActionFooterView.id)
        listView.backgroundColor = .clear
        listView.separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
