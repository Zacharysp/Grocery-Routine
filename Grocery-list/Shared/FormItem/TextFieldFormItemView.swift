//
//  TextFieldFormItemView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/14/22.
//

import UIKit
import Stevia
import Combine
import CombineCocoa

final class TextFieldFormItemView: UIView {
    
    lazy var textField = UITextField()
    
    private lazy var container = UIView()
    private lazy var imageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var wordCountLabel = UILabel()
    
    private var wordCount = 20
    
    init(title: String,
         image: UIImage,
         placeholder: String = "",
         text: String = "",
         displayWordCount: Bool = false,
         wordCount: Int = 20) {
        super.init(frame: .zero)
        titleLabel.text = title.capitalized
        imageView.image = image
        textField.text = text
        textField.placeholder = placeholder
        wordCountLabel.isHidden = !displayWordCount
        
        addViews()
        setUpViews()
    }
    
    func set(text: String) {
        textField.text = text
        updateWordCountWith(text: text)
    }
    
    func set(color: UIColor?) {
        imageView.tintColor = color
    }
    
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    private func updateWordCountWith(text: String) {
        wordCountLabel.text = "\(min(text.count, wordCount))/\(wordCount)"
    }
    
    private func addViews() {
        subviews(
            titleLabel,
            wordCountLabel,
            container.subviews(
                imageView,
                textField
            )
        )
        
        titleLabel
            .top(2)
            .left(2)
            .height(20)
        
        wordCountLabel
            .right(2)
        wordCountLabel.Left == titleLabel.Right + 2
        wordCountLabel.CenterY == titleLabel.CenterY
        
        container
            .fillHorizontally(padding: 2)
            .bottom(2)
        container.Top == titleLabel.Bottom + 2
        
        imageView
            .left(10)
            .fillVertically(padding: 10)
        imageView.Width == imageView.Height
        
        textField
            .right(.gap)
            .fillVertically(padding: 10)
        textField.Left == imageView.Right + 10
    }
    
    private func setUpViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryText
        
        wordCountLabel.font = UIFont.systemFont(ofSize: 10)
        wordCountLabel.textColor = .secondaryText
        wordCountLabel.textAlignment = .right
        
        container.backgroundColor = .gray.withAlphaComponent(0.2)
        container.layer.cornerRadius = .cornerRadius
        container.clipsToBounds = true
        
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
