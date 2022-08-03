//
//  ShopItemDetailView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/30/22.
//

import UIKit
import Stevia

enum ShopItemDetailSection: CaseIterable {
    case text
    case card
    case history
}

final class ShopItemDetailView: UIView {
    
    lazy var listNameLabel = UILabel()
    lazy var backButton = UIButton()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let layoutKind = ShopItemDetailSection.allCases[section]
            switch layoutKind {
            case .text:
                return self.buildSingleLineFullViewSection()
            case .card:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                      heightDimension: .estimated(120))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                                leading: .gap,
                                                                bottom: 0,
                                                                trailing: .gap)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: 2)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: .margin,
                                                                leading: .gap,
                                                                bottom: .margin,
                                                                trailing: .gap)
                return section
            case .history:
                let section = self.buildSingleLineFullViewSection()
                // add supplement view
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(40))
                let bottomAnchor = NSCollectionLayoutAnchor(edges: [.bottom], absoluteOffset: CGPoint(x: 0, y: .margin))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                         elementKind: UICollectionView.elementKindSectionFooter,
                                                                         alignment: .bottom,
                                                                         absoluteOffset: CGPoint(x: 0, y: .margin))
                footer.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                               leading: .gap,
                                                               bottom: 0,
                                                               trailing: .gap)
                section.boundarySupplementaryItems = [footer]
                return section
                
            }
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
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
                listNameLabel,
                backButton
            ),
            collectionView
        )
        
        topContainer
            .fillHorizontally()
            .height(50)
        topContainer.Top == self.safeAreaLayoutGuide.Top + .margin
        
        backButton
            .left(.margin)
            .centerVertically()
            .size(26)
        
        listNameLabel
            .right(.margin)
            .fillVertically()
        listNameLabel.Left == backButton.Right + .gap
        
        collectionView
            .fillHorizontally()
            .bottom(0)
        collectionView.Top == topContainer.Bottom + .gap
    }
    
    private func setUpViews() {
        backgroundColor = .background
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        backButton.setImage(UIImage(systemName: "arrow.left",
                                     withConfiguration: config),
                             for: .normal)
        
        listNameLabel.text = LocalizedString.ItemDetail.storeDetail
        listNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        collectionView.backgroundColor = .clear
        collectionView.register(ShopItemDetailTextCell.self,
                                forCellWithReuseIdentifier: ShopItemDetailTextCell.id)
        collectionView.register(ShopItemDetailCardCell.self,
                                forCellWithReuseIdentifier: ShopItemDetailCardCell.id)
        collectionView.register(ShopItemDetailHistoryCell.self,
                                forCellWithReuseIdentifier: ShopItemDetailHistoryCell.id)
        collectionView.register(CollectionReusableActionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: CollectionReusableActionView.id)
    }
    
    private func buildSingleLineFullViewSection(_ estimatedHeight: CGFloat = 200) -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                       subitem: NSCollectionLayoutItem(layoutSize: size),
                                                       count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: .margin,
                                                      bottom: 0,
                                                      trailing: .margin)
        return NSCollectionLayoutSection(group: group)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
