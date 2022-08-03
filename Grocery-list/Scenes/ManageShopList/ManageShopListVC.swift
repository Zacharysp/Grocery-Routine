//
//  ManageShopListVC.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/15/22.
//

import UIKit
import Combine

final class ManageShopListVC: UIViewController {
    
    typealias ManageShopListDataSouce = UITableViewDiffableDataSource<Int, ShopList>
    
    private lazy var contentView = ManageShopListView()
    private let viewModel: ManageShopListViewModel
    private var bindings = Set<AnyCancellable>()
    
    lazy var dataSource: ManageShopListDataSouce = {
        let dataSource = ManageShopListDataSouce(tableView: contentView.listView,
                                                 cellProvider: { tableView, indexPath, shopList in
            let cell = tableView.dequeueReusableCell(withIdentifier: ManageShopListCell.id,
                                                     for: indexPath) as? ManageShopListCell
            let isSelected = self.viewModel.currentIndex == indexPath.item
            cell?.viewModel = ManageShopListCellViewModel(shopList: shopList, isSelected: isSelected)
            
            cell?.nameTextfield.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] text in
                    guard cell!.nameTextfield.isUserInteractionEnabled,
                          let newName = text,
                          newName.count > 0 else { return }
                    if newName.count > 20 {
                        // limit list name to 20.
                        cell?.nameTextfield.text = String(newName.prefix(20))
                    }
                }.store(in: &self.bindings)
            cell?.nameTextfield.addTarget(self, action: #selector(self.nameTextFieldEditEnd(sender:)), for: .editingDidEnd)
            cell?.nameTextfield.tag = indexPath.item
            return cell
        })
        return dataSource
    }()
    
    weak var coordinator: MainCoordinator?
    
    init(viewModel: ManageShopListViewModel = ManageShopListViewModel(shopLists: [ShopList.defaultShopList])) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        bindViewToViewModel()
        bindViewModelToView()
        setUpTableView()
        setUpKeyboard()
    }
    
    private func bindViewModelToView() {
        viewModel.$shopLists
            .receive(on: RunLoop.main)
            .sink { [weak self] shopLists in
                self?.update(shopLists: shopLists)
            }.store(in: &bindings)
        
        viewModel.$themeColor
            .receive(on: RunLoop.main)
            .sink { [weak self] color in
                self?.contentView.setTheme(color: color)
            }.store(in: &bindings)
    }
    
    private func bindViewToViewModel() {
        contentView.backButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.coordinator?.navigationController.dismiss(animated: true)
            }.store(in: &bindings)
    }
    
    private func setUpKeyboard() {
        NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .receive(on: RunLoop.main)
            .sink { notification in
                if let userInfo = notification.userInfo,
                   let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self.contentView.updateTableView(height: rect.height)
                }
            }.store(in: &bindings)
        NotificationCenter.default.publisher(for: UIApplication.keyboardDidHideNotification)
            .receive(on: RunLoop.main)
            .sink { _ in
                self.contentView.updateTableView(height: 0)
            }.store(in: &bindings)
        setUpToHideKeyboardOnTapOnView()
    }
    
    private func update(shopLists: [ShopList]) {
        var snapShot = dataSource.snapshot()
        if snapShot.sectionIdentifiers.count == 0 {
            snapShot.appendSections([0])
        }
        let currentIdentifiers = snapShot.itemIdentifiers
        let diff = shopLists.difference(from: currentIdentifiers)
        guard let newIdentifiers = currentIdentifiers.applying(diff) else {
            // no difference between new and current here.
            return
        }
        snapShot.deleteItems(currentIdentifiers)
        snapShot.appendItems(newIdentifiers)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    private func setUpTableView() {
        contentView.listView.delegate = self
    }
    
    @objc func nameTextFieldEditEnd(sender: UITextField) {
        guard let name = sender.text, name.count > 0 else { return }
        viewModel.storeShopList(name: name, index: sender.tag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ManageShopListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.currentIndex != indexPath.item else { return }
        let shopList = viewModel.shopLists[indexPath.item]
        guard shopList.name.count > 0 else { return }
        
        coordinator?.delegate?.select(shopList: viewModel.shopLists[indexPath.item])
        coordinator?.navigationController.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: TableViewActionFooterView.id) as? TableViewActionFooterView else {
            return nil
        }
        view.actionButton.addTarget(self, action: #selector(addItemPressed), for: .touchUpInside)
        view.set(type: .add)
        view.setTheme(color: self.viewModel.themeColor)
        return view
    }
    
    @objc private func addItemPressed() {
        viewModel.createNewShopList()
    }
}
