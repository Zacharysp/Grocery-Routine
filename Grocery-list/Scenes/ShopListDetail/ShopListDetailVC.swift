//
//  ShopListDetailVC.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/14/22.
//

import UIKit
import Combine
import CombineCocoa

final class ShopListDetailVC: UIViewController {
    
    private lazy var contentView = ShopListDetailView()
    private let viewModel: ShopListDetailViewModel
    private var bindings = Set<AnyCancellable>()
    
    weak var coordinator: MainCoordinator?
    
    init(viewModel: ShopListDetailViewModel = ShopListDetailViewModel(shopList: ShopList.defaultShopList)) {
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
        contentView.nameTextField.set(text: viewModel.shopListName)
    }
    
    private func bindViewModelToView() {
        viewModel.$themeColor
            .receive(on: RunLoop.main)
            .sink { [weak self] color in
                self?.contentView.setTheme(color: color)
            }.store(in: &bindings)
    }
    
    private func bindViewToViewModel() {
        contentView.nameTextField.textField.textPublisher
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] input in
                guard let text = input else { return }
                // text count limit 20
                let name = String(text.prefix(20))
                self?.contentView.nameTextField.set(text: name)
                self?.viewModel.saveShopList(name: name)
            }.store(in: &bindings)
        
        contentView.backButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.coordinator?.navigationController.dismiss(animated: true)
            }.store(in: &bindings)
        
        contentView.themeColorView.pickPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.presentColorPicker()
            }.store(in: &bindings)
        
        contentView.deleteButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.presentDeleteAlert()
            }.store(in: &bindings)
    }
    
    private func presentColorPicker() {
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.selectedColor = viewModel.themeColor ?? .primary
        picker.publisher(for: \.selectedColor)
            .receive(on: RunLoop.main)
            .sink { newColor in
                self.viewModel.save(newColor: newColor)
            }.store(in: &bindings)
        present(picker, animated: true)
    }
    
    private func presentDeleteAlert() {
        let confirmButton = AlertButton(color: .red)
        confirmButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.navigationController.dismiss(animated: true)
                self.coordinator?.delegate?.delete(shopList: self.viewModel.shopList)
            }.store(in: &bindings)
        let presentAlertView = AlertView(title: LocalizedString.confirmDeleteListTitle,
                                         subtitle: LocalizedString.confirmDeleteListMessage,
                                         buttons: [confirmButton],
                                         themeColor: .red)
        let presenter = AlertPresenter(presentView: presentAlertView)
        presenter.present()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


