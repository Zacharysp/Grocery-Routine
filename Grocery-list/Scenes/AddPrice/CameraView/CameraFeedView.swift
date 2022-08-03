//
//  CameraFeedView.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/17/22.
//

import UIKit
import AVFoundation

final class CameraFeedView: UIView {
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var scanSquarelayer: CAShapeLayer?
    
    init() {
        super.init(frame: .zero)
    }
    
    func setUp(session: AVCaptureSession) {
        previewLayer = layer as? AVCaptureVideoPreviewLayer
        previewLayer?.session = session
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
    }
    
    func drawScanSquare() {
        guard scanSquarelayer == nil else { return }
        scanSquarelayer = ScanSquareLayer(outsideRect: frame)
        layer.addSublayer(scanSquarelayer!)
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
