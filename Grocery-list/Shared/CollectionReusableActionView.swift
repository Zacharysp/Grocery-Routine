//
//  CollectionReusableActionView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/7/22.
//

import UIKit
import Stevia

final class CollectionReusableActionView: UICollectionReusableView {
    static let id = "CollectionReusableActionViewId"
    
    private lazy var container = UIView()
    lazy var actionButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setUpViews()
    }
    
    func setTheme(color: UIColor?) {
        actionButton.tintColor = color
    }
    
    func set(type: ActionType) {
        switch type {
        case .add:
            actionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        case .delete:
            actionButton.setTitle(LocalizedString.delete, for: .normal)
            actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            actionButton.backgroundColor = .red
        }
    }
    
    private func addViews() {
        subviews(
            container.subviews(actionButton)
        )
        
        container
            .top(.gap)
            .bottom(2)
            .fillHorizontally(padding: .gap)
            .height(40)
        
        actionButton.followEdges(container)
    }
    
    private func setUpViews() {
        container.backgroundColor = .gray.withAlphaComponent(0.2)
        container.layer.cornerRadius = .cornerRadius
        container.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


