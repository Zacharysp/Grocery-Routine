//
//  UIViewController+DismissKeyboard.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/16/22.
//

import UIKit

extension UIViewController
{
    func setUpToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
