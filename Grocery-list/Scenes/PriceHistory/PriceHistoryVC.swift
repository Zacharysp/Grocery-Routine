//
//  PriceHistoryVC.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/21/22.
//

import UIKit

import UIKit
import Combine

final class PriceHistoryVC: UIViewController {
    
    typealias PriceHistoryDataSouce = UITableViewDiffableDataSource<Int, ShopRecord>
    
    private lazy var contentView = PriceHistoryView()
    private let viewModel: PriceHistoryViewModel
    private var bindings = Set<AnyCancellable>()
    private var cellBindings = Set<AnyCancellable>()
    
    private lazy var dataSource: PriceHistoryDataSouce = {
        let dataSource = PriceHistoryDataSouce(tableView: contentView.listView,
                                               cellProvider: { tableView, indexPath, shopRecord in
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceHistoryCell.id,
                                                     for: indexPath) as? PriceHistoryCell
            cell?.viewModel = PriceHistroyCellViewModel(record: shopRecord)
            cell?.deleteButton.tapPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] in
                    self?.presentDeleteAlert(record: shopRecord)
                }.store(in: &self.cellBindings)
            cell?.setTheme(color: self.viewModel.themeColor)
            return cell
        })
        return dataSource
    }()
    
    weak var coordinator: ShopItemCoordinator?
    
    init(viewModel: PriceHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        bindViewToViewModel()
        bindViewModelToView()
        setUpView()
    }
    
    private func bindViewToViewModel() {
        contentView.backButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.coordinator?.navigationController.popViewController(animated: true)
            }.store(in: &bindings)
    }
    
    private func bindViewModelToView() {
        viewModel.$recordGroups
            .receive(on: RunLoop.main)
            .sink { [weak self] recordGroups in
                self?.update(recordGroups: recordGroups)
            }.store(in: &bindings)
        
        viewModel.$themeColor
            .receive(on: RunLoop.main)
            .sink { color in
                self.contentView.setTheme(color: color)
            }.store(in: &bindings)
    }
    
    private func update(recordGroups: [ShopRecordGroup]) {
        cellBindings.removeAll()
        var snapShot = NSDiffableDataSourceSnapshot<Int, ShopRecord>()
        
        for (section, group) in recordGroups.enumerated() {
            snapShot.appendSections([section])
            snapShot.appendItems(group.records, toSection: section)
        }
        dataSource.apply(snapShot, animatingDifferences: true)
        
        contentView.emptyLabel.isHidden = recordGroups.count != 0
    }
    
    private func setUpView() {
        contentView.itemNameLabel.text = viewModel.itemName
        contentView.listView.delegate = self
    }
    
    private func presentDeleteAlert(record: ShopRecord) {
        let confirmButton = AlertButton(color: viewModel.themeColor)
        confirmButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.delete(record: record)
            }.store(in: &bindings)
        let presentAlertView = AlertView(title: LocalizedString.confirmRecordTitle,
                                         subtitle: LocalizedString.confirmRecordMessage,
                                         buttons: [confirmButton],
                                         themeColor: viewModel.themeColor)
        let presenter = AlertPresenter(presentView: presentAlertView)
        presenter.present()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PriceHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < viewModel.recordGroups.count else { return nil }
        let recordGroup = viewModel.recordGroups[section]
        let container = UIView()
        container.backgroundColor = .background
        let monthLabel = UILabel()
        container.subviews(monthLabel)
        monthLabel
            .fillVertically(padding: .margin)
            .fillHorizontally(padding: .margin)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        let monthAttrStr = NSMutableAttributedString(string: dateFormatter.monthSymbols[recordGroup.month - 1],
                                                     attributes: [
                                                        .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
                                                     ])
        let yearAtrStr = NSAttributedString(string: " \(String(recordGroup.year))",
                                                   attributes: [
                                                      .font: UIFont.systemFont(ofSize: 14)
                                                   ])
        monthAttrStr.append(yearAtrStr)
        monthLabel.attributedText = monthAttrStr
        return container
    }
}
