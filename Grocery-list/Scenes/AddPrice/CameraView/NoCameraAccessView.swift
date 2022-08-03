//
//  NoCameraAccessView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/20/22.
//

import UIKit
import Stevia

final class NoCameraAccessView: UIView {
    
    private let noCameraLabel = UILabel()
    private let settingButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        addViews()
        setUpViews()
    }
    
    private func addViews() {
        subviews(
            noCameraLabel,
            settingButton
        )
        
        noCameraLabel
            .left(15%)
            .width(70%)
            .centerVertically(offset: -20)
        
        settingButton
            .centerHorizontally()
            .height(36)
            .width(120)
        settingButton.Top == noCameraLabel.Bottom + .gap
    }
    
    private func setUpViews() {
        noCameraLabel.text = LocalizedString.AddPrice.noCameraAccess
        noCameraLabel.numberOfLines = 0
        
        settingButton.setTitle(LocalizedString.AddPrice.goToSetting, for: .normal)
        settingButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        settingButton.layer.cornerRadius = .cornerRadius
        settingButton.layer.masksToBounds = true
        settingButton.backgroundColor = .gray
    }
    
    @objc private func buttonPressed() {
        guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
