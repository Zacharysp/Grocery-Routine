//
//  Coordinator.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/11/22.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
