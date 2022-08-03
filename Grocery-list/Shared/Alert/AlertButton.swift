//
//  AlertButton.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/23/22.
//

import UIKit

final class AlertButton: UIButton {
    
    init(title: String = LocalizedString.confirm,
         color: UIColor? = .primary,
         height: CGFloat = 40,
         width: CGFloat = 200) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        backgroundColor = color
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        layer.cornerRadius = .cornerRadius
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
