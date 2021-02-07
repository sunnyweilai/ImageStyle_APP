//
//  ImageManager.swift
//  ImageStyle
//
//  Created by sunnywei on 2021-01-23.
//

import Foundation
import SwiftUI

class ImageManager: ObservableObject {
    
    init() {}
    
    public static var shared: ImageManager = {
        let shared = ImageManager()
        return shared
    }()
    
    /// this is used to verify if both images are selected to go to next step
    @Published var pubImagesAreReady = false
    
    public func ImagesAreReady(_ contentImg: Image?, _ styleImg: Image?){
        guard let  _ = contentImg, let _ = styleImg  else {
            AlertController.presentAlert(title: nil, message: "Please select the image")
            return
        }
    }
}
