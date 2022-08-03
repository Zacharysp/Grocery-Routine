//
//  AddShopItemVC.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/15/22.
//

import UIKit
import Combine

final class AddShopItemVC: UIViewController {
    
    private enum ItemGuessSection: Int {
        case main
    }
    private typealias ItemGuessDataSource = UICollectionViewDiffableDataSource<ItemGuessSection, ShopItemGuess>
    
    private lazy var contentView = AddShopItemView()
    private let viewModel: AddShopItemViewModel
    private var bindings = Set<AnyCancellable>()
    
   
    private lazy var itemGuessDataSource: ItemGuessDataSource = {
        let dataSource = ItemGuessDataSource(collectionView: contentView.collectionView,
                                             cellProvider: { collectionView, indexPath, itemGuess in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemGuessCell.id, for: indexPath) as? ItemGuessCell
            cell?.nameLabel.text = itemGuess.name.capitalized
            cell?.setTheme(color: self.viewModel.themeColor)
            return cell
        })
        return dataSource
    }()
    
    weak var coordinator: MainCoordinator?
    
    init(viewModel: AddShopItemViewModel = AddShopItemViewModel(shopList: ShopList.defaultShopList)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        bindViewToViewModel()
        bindViewModelToView()
        setupCollectionView()
        
        let _ = contentView.nameTextField.becomeFirstResponder()
    }
    
    private func bindViewModelToView() {
        viewModel.isValid
            .receive(on: RunLoop.main)
            .sink { [weak self] isValid in
                self?.contentView.saveButton.isHidden = !isValid
            }.store(in: &bindings)
        
        viewModel.$themeColor
            .receive(on: RunLoop.main)
            .sink { color in
                self.contentView.setTheme(color: color)
            }.store(in: &bindings)
        
        viewModel.$itemGuesses
            .receive(on: RunLoop.main)
            .sink { itemGuesses in
                self.update(itemGuesses: itemGuesses)
            }.store(in: &bindings)
    }
    
    private func bindViewToViewModel() {
        contentView.nameTextField.textField.textPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap{ $0 }
            .sink { [weak self] text in
                // text count limit 20
                let name = String(text.prefix(20))
                self?.contentView.nameTextField.set(text: name)
                self?.viewModel.shopItemName = name
                self?.viewModel.search(key: name)
            }.store(in: &bindings)
        
        contentView.backButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.coordinator?.navigationController.dismiss(animated: true)
            }.store(in: &bindings)
        
        contentView.saveButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.store()
                self?.coordinator?.navigationController.dismiss(animated: true)
            }.store(in: &bindings)
    }
    
    private func update(itemGuesses: [ShopItemGuess]) {
        var snapShot = itemGuessDataSource.snapshot()
        if snapShot.numberOfSections == 0 {
            snapShot.appendSections([.main])
        }
        let currentIdentifiers = snapShot.itemIdentifiers
        let diff = itemGuesses.difference(from: currentIdentifiers)
        
        guard let newIdentifiers = currentIdentifiers.applying(diff) else {
            // no difference between new and current here.
            return
        }
        snapShot.deleteItems(currentIdentifiers)
        snapShot.appendItems(newIdentifiers, toSection: .main)
        itemGuessDataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func setupCollectionView() {
        contentView.collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddShopItemVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let content = viewModel.itemGuesses[indexPath.item].name as NSString
        return ItemGuessCell.sizeFor(content: content)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemGuess = viewModel.itemGuesses[indexPath.item]
        viewModel.store(name: itemGuess.name.capitalized)
        coordinator?.navigationController.dismiss(animated: true)
    }
}
