//
//  DoneButton.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/20/22.
//

import UIKit
import Combine

final class DoneButton: UIImageView {
    
    var isValid: Bool = false {
        didSet {
            setValid()
        }
    }
    var tapPublisher: AnyPublisher<Void, Never> {
        tapSubject.eraseToAnyPublisher()
    }
    var highlightColor: UIColor?
    
    private let tapSubject = PassthroughSubject<Void, Never>()
    private var tapGesture: UITapGestureRecognizer!
    
    init() {
        super.init(frame: .zero)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        image = UIImage(systemName: "checkmark.rectangle.fill", withConfiguration: config)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.isEnabled = false
        addGestureRecognizer(tapGesture)
        
        isUserInteractionEnabled = true
    }
    
    private func setValid() {
        tintColor = isValid ? highlightColor : .gray
        tapGesture.isEnabled = isValid
    }
    
    @objc func tapped() {
        tapSubject.send()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
