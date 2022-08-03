//
//  PriceHistoryView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/21/22.
//

import UIKit
import Stevia

final class PriceHistoryView: UIView {
    
    
    lazy var itemNameLabel = UILabel()
    lazy var backButton = UIButton()
    lazy var listView = UITableView()
    lazy var emptyLabel = UILabel()
    
    private lazy var topContainer = UIView()
    
    init() {
        super.init(frame: .zero)
        addViews()
        setUpViews()
    }
    
    func setTheme(color: UIColor?) {
        backButton.tintColor = color
    }
    
    private func addViews() {
        subviews(
            topContainer.subviews(
                backButton,
                itemNameLabel
            ),
            listView,
            emptyLabel
        )
        
        topContainer
            .fillHorizontally()
            .height(50)
        topContainer.Top == self.safeAreaLayoutGuide.Top + .margin
        
        backButton
            .left(.margin)
            .centerVertically()
            .size(26)
        
        itemNameLabel
            .right(.margin)
            .fillVertically()
        itemNameLabel.Left == backButton.Right + .gap
        
        listView.fillHorizontally()
        listView.Top == topContainer.Bottom + .gap
        listView.Bottom == safeAreaLayoutGuide.Bottom
        
        emptyLabel.centerInContainer()
    }
    
    private func setUpViews() {
        backgroundColor = .background
        
        itemNameLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        backButton.setImage(UIImage(systemName: "arrow.left",
                                     withConfiguration: config),
                             for: .normal)

        listView.register(PriceHistoryCell.self, forCellReuseIdentifier: PriceHistoryCell.id)
        listView.backgroundColor = .clear
        listView.separatorStyle = .none
        listView.showsVerticalScrollIndicator = false
        
        emptyLabel.font = UIFont.systemFont(ofSize: 26)
        emptyLabel.text = LocalizedString.PriceHistory.noHistory
        emptyLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
