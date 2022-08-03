//
//  ManageShopListView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/15/22.
//

import UIKit
import Stevia

final class ManageShopListView: UIView {
    
    lazy var backButton = UIButton()
    lazy var listView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var topContainer = UIView()
    private lazy var titleLabel = UILabel()
    private var listViewBottomConstraint: NSLayoutConstraint?
    
    init() {
        super.init(frame: .zero)
        addViews()
        setUpViews()
    }
    
    func setTheme(color: UIColor?) {
        backButton.tintColor = color
    }
    
    func updateTableView(height: CGFloat) {
        let lastRow = listView.numberOfRows(inSection: 0) - 1
        guard lastRow > 0 else { return }
        // update tableview bottom anchor constant, keep it above keyboard
        UIView.animate(withDuration: 0.2) {
            self.listViewBottomConstraint?.constant = 0 - height - .gap
        } completion: { _ in
            guard height > 0 else { return }
            // needs to scroll to the bottom row.
            let indexPath = IndexPath(item: lastRow, section: 0)
            self.listView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func addViews() {
        subviews(
            topContainer.subviews(
                titleLabel,
                backButton
            ),
            listView
        )
        
        topContainer
            .fillHorizontally()
            .height(50)
        topContainer.Top == self.safeAreaLayoutGuide.Top + .margin
        
        backButton
            .left(.gap)
            .centerVertically()
            .size(26)
        
        titleLabel
            .fillVertically()
            .fillHorizontally(padding: .margin)
        
        listView.fillHorizontally()
        listView.Top == topContainer.Bottom + .gap
        listViewBottomConstraint = listView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                                    constant: .gap)
        listViewBottomConstraint?.isActive = true
    }
    
    private func setUpViews() {
        backgroundColor = .background
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        backButton.setImage(UIImage(systemName: "arrow.left",
                                     withConfiguration: config),
                             for: .normal)
        backButton.tintColor = .text
        
        titleLabel.text = LocalizedString.ManageShopList.title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        
        listView.register(ManageShopListCell.self, forCellReuseIdentifier: ManageShopListCell.id)
        listView.register(TableViewActionFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewActionFooterView.id)
        listView.backgroundColor = .clear
        listView.separatorStyle = .none
        listView.showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
