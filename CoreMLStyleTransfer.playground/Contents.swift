import PlaygroundSupport
import UIKit
import CoreML

class ViewController : UIViewController {
    
    // #pragma mark - UIImages
    // All images should be 720px * 720px
    
    let mainImages = ["WomanMask.jpg", "Schilthorn.jpg", "PinkRoses.jpg", "Bird.jpg"]
    var currentImage = 0
    
    // #pragma mark - UIViews
    
    lazy var mainView = {
        () -> UIView in
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = self.mainImageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let viewBindings = [
            "imageView" : imageView
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: [], metrics: nil, views: viewBindings))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: [], metrics: nil, views: viewBindings))
        view.backgroundColor = .black
        
        return view
    }()
    
    lazy var mainImageView = {
        () -> UIImageView in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return imageView
    }()
    
    // #pragma mark - UILayout
    
    override func loadView() {
        mainImageView.image = UIImage(named: self.mainImages[self.currentImage])
        
        let resetButton = UIButton(type: .system)
        resetButton.addTarget(self, action: #selector(changeImage), for: .primaryActionTriggered)
        resetButton.setTitle(NSLocalizedString("Change Image", comment: "Change Image"), for: .normal)
        resetButton.setTitleColor(UIColor.white, for: .normal)
        
        let fnsFeathersButton = UIButton(type: .system)
        fnsFeathersButton.addTarget(self, action: #selector(feathersStyleTransfer), for: .primaryActionTriggered)
        fnsFeathersButton.setTitle(NSLocalizedString("FNS Feathers", comment: "FNS Feathers"), for: .normal)
        fnsFeathersButton.setTitleColor(UIColor.white, for: .normal)
        
        let fnsMosaicButton = UIButton(type: .system)
        fnsMosaicButton.addTarget(self, action: #selector(mosaicStyleTransfer), for: .primaryActionTriggered)
        fnsMosaicButton.setTitle(NSLocalizedString("FNS Mosaic", comment: "FNS Mosaic"), for: .normal)
        fnsMosaicButton.setTitleColor(UIColor.white, for: .normal)
        
        let fnsMuseButton = UIButton(type: .system)
        fnsMuseButton.addTarget(self, action: #selector(museStyleTransfer), for: .primaryActionTriggered)
        fnsMuseButton.setTitle(NSLocalizedString("FNS La Muse", comment: "FNS La Muse"), for: .normal)
        fnsMuseButton.setTitleColor(UIColor.white, for: .normal)
        
        let buttonBar = UIStackView(arrangedSubviews:[resetButton, fnsFeathersButton, fnsMosaicButton, fnsMuseButton])
        buttonBar.axis = .horizontal
        buttonBar.distribution = .fillEqually
        buttonBar.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        let rootStackView = UIStackView(arrangedSubviews:[mainView, buttonBar])
        rootStackView.axis = .vertical
        rootStackView.distribution = .fill
        
        self.view = rootStackView
    }
    
    // #pragma mark - IBActions
    
    @IBAction func changeImage() {
        print("Playground STATUS: Changing image")
        
        self.currentImage = self.currentImage < self.mainImages.count - 1 ?  self.currentImage + 1 : 0
        
        mainImageView.image = UIImage(named: self.mainImages[self.currentImage])
        mainView.setNeedsLayout()
    }
    
    @IBAction func feathersStyleTransfer() throws {
        print("Playground STATUS: Performing FNS Feathers Style Transfer")

        let model = FNS_Feathers_1()
        guard let img = UIImage(named: self.mainImages[self.currentImage]) else { return }
        
        if let image = pixelBuffer(from: img) {
            do {
                let predictionOutput = try model.prediction(inputImage: image)
                
                let ciImage = CIImage(cvPixelBuffer: predictionOutput.outputImage)
                let tempContext = CIContext(options: nil)
                let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.outputImage), height: CVPixelBufferGetHeight(predictionOutput.outputImage)))
                
                guard let outputImg = tempImage else { return }
                
                mainImageView.image = UIImage(cgImage: outputImg)
                mainView.setNeedsLayout()
            } catch let error as NSError {
                print("CoreML Model Error: \(error)")
            }
        } else {
            print("Failed to Create Pixel Buffer Image")
        }
    }

    @IBAction func mosaicStyleTransfer() throws {
        print("Playground STATUS: Performing FNS Mosaic Style Transfer")
        
        let model = FNS_Mosaic_1()
        guard let img = UIImage(named: self.mainImages[self.currentImage]) else { return }
        
        if let image = pixelBuffer(from: img) {
            do {
                let predictionOutput = try model.prediction(inputImage: image)
                
                let ciImage = CIImage(cvPixelBuffer: predictionOutput.outputImage)
                let tempContext = CIContext(options: nil)
                let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.outputImage), height: CVPixelBufferGetHeight(predictionOutput.outputImage)))
                
                guard let outputImg = tempImage else { return }
                
                mainImageView.image = UIImage(cgImage: outputImg)
                mainView.setNeedsLayout()
            } catch let error as NSError {
                print("CoreML Model Error: \(error)")
            }
        } else {
            print("Failed to Create Pixel Buffer Image")
        }
    }
    
    @IBAction func museStyleTransfer() {
        print("Playground STATUS: Performing FNS La Muse Style Transfer")
        
        let model = FNS_La_Muse_1()
        guard let img = UIImage(named: self.mainImages[self.currentImage]) else { return }
        
        if let image = pixelBuffer(from: img) {
            do {
                let predictionOutput = try model.prediction(inputImage: image)
                
                let ciImage = CIImage(cvPixelBuffer: predictionOutput.outputImage)
                let tempContext = CIContext(options: nil)
                let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.outputImage), height: CVPixelBufferGetHeight(predictionOutput.outputImage)))
                
                guard let outputImg = tempImage else { return }
                
                mainImageView.image = UIImage(cgImage: outputImg)
                mainView.setNeedsLayout()
            } catch let error as NSError {
                print("CoreML Model Error: \(error)")
            }
        } else {
            print("Failed to Create Pixel Buffer Image")
        }
    }
    
    // #pragma mark - CoreML Image Helpers
    
    func pixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

// #pragma mark - Playground Page

let viewController = ViewController()
viewController.preferredContentSize = CGSize(width: 600, height: 640)

PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true
