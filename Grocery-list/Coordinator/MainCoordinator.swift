//
//  MainCoordinator.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/11/22.
//

import UIKit

protocol MainCoordinatorDeleage {
    func select(shopList: ShopList)
    func delete(shopList: ShopList)
}

final class MainCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    var delegate: MainCoordinatorDeleage?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        let vc = MainListVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    // mocking data for UI screen shot, should be comment out in production
//    func startWithMockDate() {
//        let mockRealmSerivce = MockImMemoryRealmServices()
//        mockRealmSerivce.loadPreset(mockingData: mockingDataUS)
//
//        let vc = MainListVC(viewModel: MainListViewModel(realmServices: mockRealmSerivce))
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: false)
//    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, childCoordinator) in childCoordinators.enumerated() {
            if childCoordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    // MARK: bridges
    
    func edit(shopList: ShopList) {
        let vc = ShopListDetailVC(viewModel: ShopListDetailViewModel(shopList: shopList))
        vc.coordinator = self
        navigationController.present(vc, animated: true)
    }
    
    func addNewShopItemTo(shopList: ShopList) {
        let vc = AddShopItemVC(viewModel: AddShopItemViewModel(shopList: shopList))
        vc.coordinator = self
        navigationController.present(vc, animated: true)
    }
    
    func manage(shopLists: [ShopList], currentSelectedIndex: Int) {
        let vc = ManageShopListVC(viewModel: ManageShopListViewModel(shopLists: shopLists, currentIndex: currentSelectedIndex))
        vc.coordinator = self
        navigationController.present(vc, animated: true)
    }
    
    func addPriceFor(shopItem: ShopItem, themeColor: UIColor?) {
        let vc = AddPriceVC(viewModel: AddPriceViewModel(shopItem: shopItem, themeColor: themeColor))
        vc.coordinator = self
        navigationController.present(vc, animated: true)
    }
    
    func edit(shopItem: ShopItem, themeColor: UIColor?) -> ShopItemCoordinator {
        let childNavi = UINavigationController()
        let child = ShopItemCoordinator(navigationController: childNavi,
                                        shopItem: shopItem,
                                        themeColor: themeColor)
        child.parentCoordinator = self
        child.start()
        
        childCoordinators.append(child)
        childNavi.presentationController?.delegate = child
        navigationController.present(childNavi, animated: true)
        
        return child
    }
}
