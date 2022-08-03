//
//  MainListVC.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/11/22.
//

import UIKit
import Combine

final class MainListVC: UIViewController {
    
    typealias MainListDataSource = UITableViewDiffableDataSource<Int, ShopItem>
    
    private lazy var contentView = MainListView()
    private let viewModel: MainListViewModel
    private var cellBindings = Set<AnyCancellable>()
    private var bindings = Set<AnyCancellable>()
    
    weak var coordinator: MainCoordinator?
    
    private lazy var dataSource: MainListDataSource = {
        return MainListDataSource(tableView: contentView.listView,
                                            cellProvider: { tableView, indexPath, shopItem in
            let cell = tableView.dequeueReusableCell(withIdentifier: MainListCell.id,
                                                     for: indexPath) as? MainListCell
            cell?.viewModel = MainListCellViewModel(item: shopItem)
            cell?.setTheme(color: self.viewModel.themeColor)
            cell?.detailButton.tapPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] in
                    let shopItemCoordinator = self?.coordinator?.edit(shopItem: shopItem,
                                                                      themeColor: self?.viewModel.themeColor)
                    shopItemCoordinator?.delegate = self
                }.store(in: &self.cellBindings)
            return cell
        })
    }()
    
    init(viewModel: MainListViewModel = MainListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        bindViewModelToView()
        bindViewToViewModel()
        setUpTableView()
        
        coordinator?.delegate = self
        viewModel.fetchShopList()
    }
    
    private func bindViewModelToView() {
        viewModel.$currentShopList
            .receive(on: RunLoop.main)
            .compactMap{ $0 }
            .sink { [weak self] list in
                self?.contentView.switchTo(list: list)
            }
            .store(in: &bindings)
        
        viewModel.$shopItems
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                self?.update(newItems: items)
            }.store(in: &bindings)
        
        viewModel.$themeColor
            .receive(on: RunLoop.main)
            .sink { [weak self] color in
                self?.contentView.setTheme(color: color)
            }.store(in: &bindings)
    }
    
    private func bindViewToViewModel() {
        contentView.manageStoreButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let viewModel = self?.viewModel else { return }
                self?.coordinator?.manage(shopLists: viewModel.shopLists,
                                          currentSelectedIndex: viewModel.currentSelectedIndex())
            }.store(in: &bindings)
        
        contentView.storeEditButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                
                let numbers = [0]
                      let _ = numbers[1]
                guard let shopList = self?.viewModel.currentShopList else { return }
                self?.coordinator?.edit(shopList: shopList)
            }.store(in: &bindings)
    }
    
    private func update(newItems: [ShopItem]) {
        // clean all subscriptions before update the table
        cellBindings.removeAll()
        var snapShot = dataSource.snapshot()
        if snapShot.numberOfSections == 0 {
            snapShot.appendSections([0])
        }
        let currentIdentifiers = snapShot.itemIdentifiers
        let diff = newItems.difference(from: currentIdentifiers)
        
        guard let newIdentifiers = currentIdentifiers.applying(diff) else {
            // no difference between new and current here.
            return
        }
        snapShot.deleteItems(currentIdentifiers)
        snapShot.appendItems(newIdentifiers)
        // because the realm data change will not triggle drawing the cell.
        // calling reload these cells manually.
        snapShot.reloadItems(newIdentifiers)
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func setUpTableView() {
        contentView.listView.delegate = self
    }
    
    private func presentUnCheckAlert(item: ShopItem) {
        let confirmButton = AlertButton(color: viewModel.themeColor)
        confirmButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                item.unCheckItem()
            }.store(in: &bindings)
        let presentAlertView = AlertView(title: LocalizedString.confirmUndoItemTitle,
                                         subtitle: LocalizedString.confirmUndoItemMessage,
                                         buttons: [confirmButton],
                                         themeColor: viewModel.themeColor)
        let presenter = AlertPresenter(presentView: presentAlertView)
        presenter.present()
    }
    
    private func presentDeleteAlert(item: ShopItem) {
        let confirmButton = AlertButton(color: viewModel.themeColor)
        confirmButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.delete(shopItem: item)
            }.store(in: &bindings)
        let presentAlertView = AlertView(title: LocalizedString.confirmDeleteItemTitle,
                                         subtitle: LocalizedString.confirmDeleteItemMessage,
                                         buttons: [confirmButton],
                                         themeColor: viewModel.themeColor)
        let presenter = AlertPresenter(presentView: presentAlertView)
        presenter.present()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let shopItem = viewModel.currentShopList?.shopItems[indexPath.row] else { return }
        if shopItem.isChecked() {
            presentUnCheckAlert(item: shopItem)
        } else {
            coordinator?.addPriceFor(shopItem: shopItem, themeColor: viewModel.themeColor)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: LocalizedString.delete) { [weak self] action, view, comletionHandler in
            guard let self = self,
                  let shopItem = self.viewModel.currentShopList?.shopItems[indexPath.item] else {
                return
            }
            self.presentDeleteAlert(item: shopItem)
            comletionHandler(true)
        }
        action.backgroundColor = .background
        action.image = UIImage(systemName: "trash")?.withTintColor(viewModel.themeColor ?? .primary,
                                                                   renderingMode: .alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: TableViewActionFooterView.id) as? TableViewActionFooterView else {
            return nil
        }
        view.actionButton.addTarget(self, action: #selector(addItemPressed), for: .touchUpInside)
        view.set(type: .add)
        view.setTheme(color: viewModel.themeColor)
        return view
    }
    
    @objc private func addItemPressed() {
        guard let shopList = viewModel.currentShopList else { return }
        coordinator?.addNewShopItemTo(shopList: shopList)
    }
}

extension MainListVC: MainCoordinatorDeleage {
    func delete(shopList: ShopList) {
        viewModel.delete(shopList: shopList)
    }
    
    func select(shopList: ShopList) {
        viewModel.switchTo(shopList: shopList)
    }
}

extension MainListVC: ShopItemCoordinatorDeleage {
    func delete(shopItem: ShopItem) {
        viewModel.delete(shopItem: shopItem)
    }
}
