//
//  ColorPickerItemView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/24/22.
//

import UIKit
import Combine
import Stevia

final class ColorPickerItemView: UIView {
    
    var pickPublisher: AnyPublisher<Void, Never> {
        tapSubject.eraseToAnyPublisher()
    }
    
    private lazy var titleLabel = UILabel()
    private lazy var colorView = UIView()
    private lazy var editButton = UIButton()
    
    private let tapSubject = PassthroughSubject<Void, Never>()
    private var tapGesture: UITapGestureRecognizer!
    private var colorBinding: AnyCancellable?
    
    init(color: UIColor? = nil) {
        super.init(frame: .zero)
        
        addViews()
        setUpViews()
        update(color: color)
    }
    
    func update(color: UIColor?) {
        colorView.backgroundColor = color
        editButton.tintColor = color
    }
    
    private func addViews() {
        subviews(
            titleLabel,
            colorView,
            editButton
        )
        
        titleLabel
            .left(2)
            .fillVertically(padding: 4)
            .height(30)
        
        colorView
            .centerVertically()
            .width(80)
            .height(30)
        colorView.Left >= titleLabel.Right + .gap
        
        editButton
            .right(2)
            .centerVertically()
            .size(26)
        editButton.Left == colorView.Right + .gap
    }
    
    private func setUpViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryText
        titleLabel.text = LocalizedString.themeColor
        
        colorView.layer.cornerRadius = .cornerRadius
        colorView.layer.masksToBounds = true
        colorView.isUserInteractionEnabled = true
        colorView.layer.shadowColor = UIColor.shadow.cgColor
        colorView.layer.shadowOffset = .zero
        colorView.layer.shadowOpacity = 0.5
        colorView.layer.shadowRadius = 10
        colorView.layer.shouldRasterize = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        colorView.addGestureRecognizer(tapGesture)
        
        editButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        editButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc private func tapped() {
        tapSubject.send()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
