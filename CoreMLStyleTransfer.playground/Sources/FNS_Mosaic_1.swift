//
// FNS_Mosaic.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
public class FNS_Mosaic_1Input : MLFeatureProvider {

    /// Image to stylize as color (kCVPixelFormatType_32BGRA) image buffer, 720 pixels wide by 720 pixels high
    var inputImage: CVPixelBuffer
    
    public var featureNames: Set<String> {
        get {
            return ["inputImage"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "inputImage") {
            return MLFeatureValue(pixelBuffer: inputImage)
        }
        return nil
    }
    
    public init(inputImage: CVPixelBuffer) {
        self.inputImage = inputImage
    }
}


/// Model Prediction Output Type
public class FNS_Mosaic_1Output : MLFeatureProvider {

    /// Stylized image as color (kCVPixelFormatType_32BGRA) image buffer, 720 pixels wide by 720 pixels high
    public let outputImage: CVPixelBuffer
    
    public var featureNames: Set<String> {
        get {
            return ["outputImage"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "outputImage") {
            return MLFeatureValue(pixelBuffer: outputImage)
        }
        return nil
    }
    
    public init(outputImage: CVPixelBuffer) {
        self.outputImage = outputImage
    }
}


/// Class for model loading and prediction
public class FNS_Mosaic_1 {
    var model: MLModel

    /**
        Construct a model with explicit path to mlmodel file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        let bundle = Bundle(for: FNS_Mosaic_1.self)
        let assetPath = bundle.url(forResource: "FNS_Mosaic_1", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as FNS_Mosaic_1Input
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as FNS_Mosaic_1Output
    */
    public func prediction(input: FNS_Mosaic_1Input) throws -> FNS_Mosaic_1Output {
        let outFeatures = try model.prediction(from: input)
        let result = FNS_Mosaic_1Output(outputImage: outFeatures.featureValue(for: "outputImage")!.imageBufferValue!)
        return result
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - inputImage: Image to stylize as color (kCVPixelFormatType_32BGRA) image buffer, 720 pixels wide by 720 pixels high
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as FNS_Mosaic_1Output
    */
    public func prediction(inputImage: CVPixelBuffer) throws -> FNS_Mosaic_1Output {
        let input_ = FNS_Mosaic_1Input(inputImage: inputImage)
        return try self.prediction(input: input_)
    }
}
