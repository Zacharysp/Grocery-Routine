//
//  CheckBox.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/12/22.
//

import UIKit
import Combine

final class CheckBox: UIButton {
    
    private let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
    private lazy var checkedImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
    private lazy var uncheckedImage = UIImage(systemName: "circle", withConfiguration: config)
    
    var isChecked: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.setImage(self.isChecked ? self.checkedImage: self.uncheckedImage, for: .normal)
            }
        }
    }
    
    init(color: UIColor = .primary) {
        super.init(frame: .zero)
        tintColor = color
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
