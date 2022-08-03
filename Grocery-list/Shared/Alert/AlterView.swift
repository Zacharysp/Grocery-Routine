//
//  AlterView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/23/22.
//

import UIKit
import SwiftEntryKit
import Stevia
import Combine

class AlertView: UIView {
    
    let buttons: [UIButton]
    
    private let title: String
    private let subtitle: String?
    
    private lazy var closeButton = UIButton()
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    private lazy var buttonStackView = UIStackView()
    
    private var bindings = Set<AnyCancellable>()
    private var themeColor: UIColor?
    
    init(title: String,
         subtitle: String? = nil,
         buttons: [UIButton],
         themeColor: UIColor? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.buttons = buttons
        self.themeColor = themeColor
        super.init(frame: .zero)
        
        addViews()
        setUpViews()
        setUpButtonDismissAction()
        
        Height >= 260
    }
    
    private func setUpButtonDismissAction() {
        buttons.forEach {
            $0.tapPublisher
                .receive(on: RunLoop.main)
                .sink { SwiftEntryKit.dismiss() }
                .store(in: &bindings)
        }
    }
    
    private func addViews() {
        subviews(
            titleLabel,
            subtitleLabel,
            closeButton,
            buttonStackView
        )
        
        titleLabel
            .top(.gap * 2 + 40)
            .fillHorizontally(padding: .margin)
        
        subtitleLabel.fillHorizontally(padding: .margin)
        subtitleLabel.Top == titleLabel.Bottom + .gap
        
        buttonStackView
            .fillHorizontally(padding: .margin)
            .bottom(.gap)
        buttonStackView.Top >= subtitleLabel.Bottom + .margin * 3
        
        closeButton
            .top(.gap)
            .right(.gap)
            .size(40)
    }
    
    private func setUpViews() {
        titleLabel.text = title.capitalized
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = .secondaryText
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.numberOfLines = 0
        
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillProportionally
        buttonStackView.spacing = .gap
        
        for button in buttons {
            button.fillHorizontally()
            buttonStackView.addArrangedSubview(button)
        }
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        closeButton.setImage(UIImage(systemName: "xmark.circle", withConfiguration: config),
                             for: .normal)
        closeButton.tintColor = themeColor
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
    }
    
    @objc private func closePressed() {
        SwiftEntryKit.dismiss()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
