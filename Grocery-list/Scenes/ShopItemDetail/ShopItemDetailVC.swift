//
//  ShopItemDetailVC.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/30/22.
//

import UIKit
import Combine

final class ShopItemDetailVC: UIViewController {
    
    typealias ItemDetailDataSouce = UICollectionViewDiffableDataSource<ShopItemDetailSection, AnyHashable>
    typealias ItemDetailSnapshot = NSDiffableDataSourceSnapshot<ShopItemDetailSection, AnyHashable>
    
    private lazy var contentView = ShopItemDetailView()
    private let viewModel: ShopItemDetailViewModel
    private var bindings = Set<AnyCancellable>()
    private var nameItemBinding: AnyCancellable?
    private var historyItemBinding: AnyCancellable?
    
    private lazy var dataSource: ItemDetailDataSouce = {
        let dataSource = ItemDetailDataSouce(collectionView: contentView.collectionView,
                                                 cellProvider: { collectionView, indexPath, itemDetail in
            let sectionType = ShopItemDetailSection.allCases[indexPath.section]
            switch sectionType {
            case .text:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItemDetailTextCell.id,
                                                              for: indexPath) as? ShopItemDetailTextCell
                if let nameItem = itemDetail as? ShopItemDetailName {
                    cell?.nameTextField.set(text: nameItem.name)
                }
                self.nameItemBinding = cell?.nameTextField.textField.textPublisher
                    .receive(on: RunLoop.main)
                    .removeDuplicates()
                    .sink { [weak self] input in
                        guard let text = input else { return }
                        // text count limit 20
                        let name = String(text.prefix(20))
                        cell?.nameTextField.set(text: name)
                        self?.viewModel.saveShopItem(name: name)
                    }
                cell?.setTheme(color: self.viewModel.themeColor)
                return cell
            case .card:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItemDetailCardCell.id,
                                                              for: indexPath) as? ShopItemDetailCardCell
                if let cardItem = itemDetail as? ShopItemDetailCard {
                    cell?.itemDetail = cardItem
                }
                cell?.setTheme(color: self.viewModel.themeColor)
                return cell
                
            case .history:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItemDetailHistoryCell.id,
                                                              for: indexPath) as? ShopItemDetailHistoryCell
                if let historyItem = itemDetail as? ShopItemDetailHistory {
                    cell?.set(itemDetail: historyItem,
                              themeColor: self.viewModel.themeColor)
                }
                self.historyItemBinding = cell?.historyButton.tapPublisher
                    .receive(on: RunLoop.main)
                    .sink {
                        self.coordinator?.viewHistory()
                    }
                return cell
            }
        })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: CollectionReusableActionView.id,
                                                                       for: indexPath) as? CollectionReusableActionView
            view?.set(type: .delete)
            view?.actionButton.addTarget(self, action: #selector(self.presentDeleteAlert), for: .touchUpInside)
            return view
        }
        return dataSource
    }()
    
    weak var coordinator: ShopItemCoordinator?
    
    init(viewModel: ShopItemDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        setUpViews()
        bindViewToViewModel()
        bindViewModelToView()
        setUpToHideKeyboardOnTapOnView()
    }
    
    private func setUpViews() {
        contentView.listNameLabel.text = viewModel.shopItem.shopList.first?.name ?? ""
    }
    
    private func bindViewModelToView() {
        viewModel.$themeColor
            .receive(on: RunLoop.main)
            .sink { [weak self] color in
                self?.contentView.setTheme(color: color)
            }.store(in: &bindings)
        
        viewModel.$cardItemDetails
            .receive(on: RunLoop.main)
            .sink { [weak self] cardItemDetails in
                self?.update(cardItems: cardItemDetails)
            }.store(in: &bindings)
    }
    
    private func bindViewToViewModel() {
        contentView.backButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.coordinator?.navigationController.dismiss(animated: true)
                self?.coordinator?.didFinishEditShopItem()
            }.store(in: &bindings)
    }
    
    private func update(cardItems: [ShopItemDetailCard]) {
        var snapShot = dataSource.snapshot()
        
        if snapShot.numberOfSections == 0 {
            snapShot.appendSections([.text, .card, .history])
        }
        updateNameItemTo(snapShot: &snapShot)
        update(cardItems: cardItems, to: &snapShot)
        updateHistoryItemTo(snapShot: &snapShot)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func updateNameItemTo(snapShot: inout ItemDetailSnapshot){
        guard snapShot.itemIdentifiers(inSection: .text).first == nil else {
            return
        }
        snapShot.appendItems([viewModel.nameItemDetail], toSection: .text)
    }
    
    private func update(cardItems: [ShopItemDetailCard], to snapShot: inout ItemDetailSnapshot) {
        guard cardItems.count > 0 else { return }
        
        guard let currentCardItems = snapShot.itemIdentifiers(inSection: .card) as? [ShopItemDetailCard] else {
            return
        }
        let diff = cardItems.difference(from: currentCardItems)
        
        guard let newCardItems = currentCardItems.applying(diff) else {
            return
        }
        snapShot.deleteItems(currentCardItems)
        snapShot.appendItems(newCardItems, toSection: .card)
    }
    
    private func updateHistoryItemTo(snapShot: inout ItemDetailSnapshot){
        if let currentHistoryItem = snapShot.itemIdentifiers(inSection: .history).first {
            snapShot.deleteItems([currentHistoryItem])
        }
        snapShot.appendItems([viewModel.historyItemDetail], toSection: .history)
    }
    
    @objc private func presentDeleteAlert() {
        let confirmButton = AlertButton(color: .red)
        confirmButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.delegate?.delete(shopItem: self.viewModel.shopItem)
                self.coordinator?.navigationController.dismiss(animated: true)
                self.coordinator?.didFinishEditShopItem()
            }.store(in: &bindings)
        let presentAlertView = AlertView(title: LocalizedString.confirmDeleteItemTitle,
                                         subtitle: LocalizedString.confirmDeleteItemMessage,
                                         buttons: [confirmButton],
                                         themeColor: .red)
        let presenter = AlertPresenter(presentView: presentAlertView)
        presenter.present()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
