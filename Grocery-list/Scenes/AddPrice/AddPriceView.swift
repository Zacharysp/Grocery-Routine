//
//  AddPriceView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/17/22.
//

import UIKit
import Stevia

final class AddPriceView: UIView {
    
    lazy var itemNameLable = UILabel()
    lazy var closeButton = UIButton()
    lazy var cameraFeedView = CameraFeedView()
    lazy var priceTextField = UITextField()
    lazy var doneButton = DoneButton()
    
    private let helpLabel = UILabel()
    private let noCameraView = NoCameraAccessView()
    
    init() {
        super.init(frame: .zero)
        addViews()
        setUpViews()
    }
    
    func setTheme(color: UIColor?) {
        closeButton.tintColor = color
        doneButton.highlightColor = color
    }
    
    func didOpenCamera(_ isCameraOn: Bool) {
        noCameraView.isHidden = isCameraOn
    }
    
    private func addViews() {
        subviews(
            itemNameLable,
            closeButton,
            cameraFeedView,
            priceTextField,
            helpLabel,
            doneButton,
            noCameraView
        )
        
        closeButton
            .top(.margin)
            .right(.margin)
            .size(30)
        
        itemNameLable
            .top(.margin)
            .left(.margin)
        itemNameLable.Right == closeButton.Left - .gap
        
        helpLabel.fillHorizontally(padding: .margin)
        helpLabel.Top == itemNameLable.Bottom + .margin
        
        cameraFeedView
            .fillHorizontally(padding: .margin)
        cameraFeedView.Height == cameraFeedView.Width * 0.618
        cameraFeedView.Top == helpLabel.Bottom + .gap
        
        priceTextField.left(.margin)
        priceTextField.Top == cameraFeedView.Bottom + .margin
        priceTextField.Right == doneButton.Left - .gap
        
        doneButton
            .right(.margin)
            .height(40)
            .width(60)
        doneButton.CenterY == priceTextField.CenterY
        
        noCameraView.followEdges(cameraFeedView)
    }
    
    private func setUpViews() {
        backgroundColor = .background
        
        itemNameLable.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        closeButton.setImage(UIImage(systemName: "xmark.circle", withConfiguration: config), for: .normal)
        
        helpLabel.font = UIFont.systemFont(ofSize: 16)
        helpLabel.text = LocalizedString.AddPrice.cameraGuide
        helpLabel.numberOfLines = 0
        
        cameraFeedView.layer.cornerRadius = 10
        cameraFeedView.layer.masksToBounds = true
        
        priceTextField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        priceTextField.keyboardType = .decimalPad
        priceTextField.returnKeyType = .done
        
        noCameraView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
