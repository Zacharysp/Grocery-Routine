//
//  ItemGuessCell.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/28/22.
//

import UIKit
import Stevia

class ItemGuessCell: UICollectionViewCell {
    static let id = "ItemGuessCellId"
    static private let imageSize: CGFloat = 20
    
    lazy var nameLabel = UILabel()
    private lazy var addImage = UIImageView()

    static func sizeFor(content: NSString) -> CGSize {
        let contentSize = content.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
        ])
        
        // width = | gap + name content + gap + image + margin |
        let width = .gap * 2 + contentSize.width + .gap + imageSize
        // height = | gap + name content + gap |
        let height = .gap * 2 + contentSize.height
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setUpViews()
    }
    
    func setTheme(color: UIColor?) {
        addImage.tintColor = color
    }
    
    private func addViews() {
        subviews(
            nameLabel,
            addImage
        )
        
        nameLabel
            .left(.gap)
            .fillVertically()
        
        addImage
            .right(.gap)
            .centerVertically()
            .size(ItemGuessCell.imageSize)
        addImage.Left == nameLabel.Right + .gap
    }
    
    private func setUpViews() {
        backgroundColor = .gray.withAlphaComponent(0.2)
        layer.cornerRadius = .cornerRadius
        layer.masksToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textAlignment = .center
        
        addImage.image = UIImage(systemName: "plus")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
