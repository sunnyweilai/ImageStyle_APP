//
//  ModelManager.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-04.
//

import Foundation
import Vision
import SwiftUI
import UIKit

protocol ModelType {
}

enum StyleModelType: String {
    case koreanStyle =  "KoreanStyle"
    case peachBlushStyle = "PeachBlushStyle"

    func toFilterName() -> String {
        switch self {
        case .koreanStyle:
            return "Beige Daisy"
        case .peachBlushStyle:
            return "Peach Blush"
        }
    }
}

class ModelManager: ObservableObject {
    
    var styledImage : UIImage?
    var styleModelGroup: [StyleModelType] = [StyleModelType]()
    
    @Published var contentImageStyleChanged = Date().timeIntervalSince1970
    
    public static var shared: ModelManager = {
        let shared = ModelManager()
        return shared
    }()
    
    let config = MLModelConfiguration()
  

    
    public static func applyStyle(inputImage: UIImage, style: StyleModelType){
        var outputImage: UIImage? = UIImage()
        let inputResized = inputImage.resized(to: CGSize(width: 512, height: 512))
        
        if let inputBuffer = inputResized.buffer(from: inputResized){
            do{
                if style == .koreanStyle{
                let model: KoreanStyle = try KoreanStyle(configuration: .init())
                let result = try model.prediction(image: inputBuffer)
                let outputBuffer = result.stylizedImage
                outputImage = UIImage(pixelBuffer: outputBuffer)
                }else if style == .peachBlushStyle {
                    let model: PeachBlushStyle = try PeachBlushStyle(configuration: .init())
                    let result = try model.prediction(image: inputBuffer)
                    let outputBuffer = result.stylizedImage
                    outputImage = UIImage(pixelBuffer: outputBuffer)
                }
            }catch {
                print("wrong")
            }
        }
        
        DispatchQueue.main.async{
            shared.styledImage = outputImage
            shared.contentImageStyleChanged = Date().timeIntervalSince1970
                   }
        
    }

}


