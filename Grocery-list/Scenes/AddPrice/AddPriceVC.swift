//
//  AddPriceVC.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 6/17/22.
//

import UIKit
import Combine
import AVFoundation
import Vision
import CoreMedia

enum CaptureVideoError: Error {
    case noDevice
    case noDeviceInput
    case cannotAddInput
    case cannotAddOutput
    case cannotZoomDevice
}

final class AddPriceVC: UIViewController {
    
    private lazy var contentView = AddPriceView()
    private let viewModel: AddPriceViewModel
    private var bindings = Set<AnyCancellable>()
    
    weak var coordinator: MainCoordinator?
    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInitiated,
                                                       attributes: [], autoreleaseFrequency: .workItem)
    private var cameraFeedSession: AVCaptureSession?
    
    init(viewModel: AddPriceViewModel = AddPriceViewModel(shopItem: ShopItem(), themeColor: nil)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        bindViewToViewModel()
        bindViewModelToView()
        
        contentView.priceTextField.becomeFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.openCamera()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // draw a camera scan indicator square view on feed layer.
        contentView.cameraFeedView.drawScanSquare()
    }
    private func bindViewToViewModel() {
        contentView.closeButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.coordinator?.navigationController.dismiss(animated: true)
            }.store(in: &bindings)
        
        contentView.priceTextField.textPublisher
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { price in
                guard let p = price,
                      var priceInFloat = Float(p),
                      priceInFloat > 0 else {
                    self.contentView.doneButton.isValid = false
                    return
                }
                if self.viewModel.recognizedPrice == 0 &&
                    self.viewModel.userPrice == nil &&
                    (self.contentView.priceTextField.text ?? "").count != 1 {
                    // no recognized price at this point,
                    // the third decimal number should be the first time user entered.
                    // remove all numbers before third decimal number.
                    priceInFloat = priceInFloat * 1000
                    self.contentView.priceTextField.text = "\(Int(priceInFloat))"
                }
                self.viewModel.userPrice = priceInFloat
                self.contentView.doneButton.isValid = true
            }.store(in: &bindings)
        
        contentView.doneButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                let price = self.viewModel.userPrice ?? self.viewModel.recognizedPrice
                self.viewModel.markCheckedWith(price: price)
                self.coordinator?.navigationController.dismiss(animated: true)
            }.store(in: &bindings)
    }
    
    private func bindViewModelToView() {
        viewModel.$name
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: contentView.itemNameLable)
            .store(in: &bindings)
        viewModel.$recognizedPrice
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] price in
                guard self?.viewModel.userPrice == nil else {
                    // user already type in a price
                    return
                }
                self?.contentView.priceTextField.text = String(format: "%.2f", price)
                self?.contentView.doneButton.isValid = price > 0
            }.store(in: &bindings)
        viewModel.$themeColor
            .receive(on: RunLoop.main)
            .sink { color in
                self.contentView.setTheme(color: color)
            }.store(in: &bindings)
    }
    
    private func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startCapture()
        case .notDetermined:
            // ask for permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.startCapture()
                    } else {
                        Debugger.logger.log("the user has not granted to access the camera")
                        self?.handleDismiss()
                    }
                }
            }
        case .denied:
            Debugger.logger.log("the user has denied previously to access the camera.")
            handleDismiss()
        case .restricted:
            Debugger.logger.log("the user can't give camera access due to some restriction.")
            handleDismiss()
        default:
            Debugger.logger.log("something has wrong due to we can't access the camera.")
            handleDismiss()
        }
    }
    
    private func startCapture() {
        do {
            try setupCaptureSession()
            contentView.didOpenCamera(true)
        } catch {
            Debugger.warning("Cannot start capture session, \(error)")
        }
    }
    
    func setupCaptureSession() throws {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            throw CaptureVideoError.noDevice
        }
        
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.videoZoomFactor = 1.2
            captureDevice.unlockForConfiguration()
        } catch {
            throw CaptureVideoError.cannotZoomDevice
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            throw CaptureVideoError.noDeviceInput
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = captureDevice.supportsSessionPreset(.hd1920x1080) ? .hd1920x1080 : .high
        
        guard session.canAddInput(deviceInput) else {
            throw CaptureVideoError.cannotAddInput
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        guard session.canAddOutput(dataOutput) else {
            throw CaptureVideoError.cannotAddOutput
        }
        session.addOutput(dataOutput)
        dataOutput.alwaysDiscardsLateVideoFrames = true
        dataOutput.videoSettings = [
            String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_32BGRA)
        ]
        dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        let captureConnection = dataOutput.connection(with: .video)
        captureConnection?.preferredVideoStabilizationMode = .standard
        captureConnection?.videoOrientation = .portrait
        // Always process the frames
        captureConnection?.isEnabled = true
        session.commitConfiguration()
        cameraFeedSession = session
        
        contentView.cameraFeedView.setUp(session: cameraFeedSession!)
        cameraFeedSession?.startRunning()
    }
    
    @objc private func handleDismiss() {
        contentView.didOpenCamera(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddPriceVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = process(sampleBuffer: sampleBuffer) else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
        
        let textRequest = VNRecognizeTextRequest(completionHandler: viewModel.numberDetectHandler(request:error:))
        textRequest.recognitionLanguages = ["en-US"]
        textRequest.recognitionLevel = .accurate

        do {
            try requestHandler.perform([textRequest])
        } catch {
            Debugger.warning("Unable to perform the request: \(error).")
        }
    }
    
    // only use the center part of video frame, crop the buffer image.
    private func process(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            // cannot get image buffer from this frame
            return nil
        }
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        
        guard let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer) else {
            CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
            return nil
        }
        
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        
        // define the crop size
        let size = CVImageBufferGetDisplaySize(imageBuffer)
        let cropWidth = size.width * 0.8
        let cropHeight = cropWidth * 0.618
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bytesPerPixel = UIScreen.main.scale
        let startPointX = Int((size.width - cropWidth) * 0.5)
        let startPointY = Int((size.height - cropHeight) * 0.5)
        let startAddress = baseAddress + (startPointY * bytesPerRow + startPointX * Int(bytesPerPixel))
        guard let context = CGContext(data: startAddress,
                                width: Int(cropWidth),
                                height: Int(cropHeight),
                                bitsPerComponent: 8,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
            // cannot build the context
            return nil
        }
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)

        return context.makeImage()
    }
}
