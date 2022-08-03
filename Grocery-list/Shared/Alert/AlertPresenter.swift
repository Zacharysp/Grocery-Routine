//
//  AlertPresenter.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/22/22.
//

import UIKit
import SwiftEntryKit

final class AlertPresenter {
    
    let presentView: AlertView
    private lazy var attributes = EKAttributes()
    
    init(presentView: AlertView) {
        self.presentView = presentView
        setUpView()
        setUpAttributes()
    }
    
    func present() {
        SwiftEntryKit.display(entry: presentView, using: attributes)
    }
    
    func dismiss() {
        SwiftEntryKit.dismiss()
    }
    
    private func setUpView() {
        presentView.fillContainer()
    }
    
    private func setUpAttributes() {
        attributes.windowLevel = .statusBar
        attributes.position = .bottom
        attributes.precedence = .enqueue(priority: .normal)
        attributes.displayDuration = .infinity
        attributes.positionConstraints.size = .init(width: .offset(value: 0),
                                                    height: .intrinsic)
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        attributes.scroll = .disabled
        attributes.hapticFeedbackType = .warning
        attributes.entryBackground = .color(color: EKColor(.lightGray))
        attributes.screenBackground = .color(color: EKColor(.background.withAlphaComponent(0.5)))
        attributes.shadow = .active(with: .init(color: .standardBackground, opacity: 0.3, radius: 30, offset: .zero))
        attributes.roundCorners = .top(radius: 20)
    }
}
