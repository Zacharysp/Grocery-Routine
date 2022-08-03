//
//  ShopItemCoordinator.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/5/22.
//

import UIKit

protocol ShopItemCoordinatorDeleage {
    func delete(shopItem: ShopItem)
}

final class ShopItemCoordinator: NSObject, Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    let shopItem: ShopItem
    let themeColor: UIColor?
    
    var delegate: ShopItemCoordinatorDeleage?
    
    init(navigationController: UINavigationController,
         shopItem: ShopItem,
         themeColor: UIColor?) {
        self.navigationController = navigationController
        self.shopItem = shopItem
        self.themeColor = themeColor
        
        navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        let vc = ShopItemDetailVC(viewModel: ShopItemDetailViewModel(shopItem: shopItem, themeColor: themeColor))
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func viewHistory() {
        let vc = PriceHistoryVC(viewModel: PriceHistoryViewModel(shopItem: shopItem, themeColor: themeColor))
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinishEditShopItem() {
        parentCoordinator?.childDidFinish(self)
    }
}

extension ShopItemCoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        didFinishEditShopItem()
    }
}
