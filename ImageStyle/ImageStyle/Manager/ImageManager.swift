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
    
    /// this is the content image displayed on the view
    @Published var pubContentImage: Image?
    
    /// this is used to verify if both images are selected to go to next step
    @Published var pubImagesAreReady = false
    
    /// this is used to verify if the share image is ready
    @Published var pubSnapImageReady = false
    
    @Published var pubSnapImageLastUpdated = Date().timeIntervalSince1970

    public var snapImage : UIImage?
    public var hidingShareButton = false
    
    public func ImagesAreReady(_ contentImg: Image?) -> Bool{
        var isReady = true
        guard let  _ = contentImg else {
            AlertController.presentAlert(title: nil, message: "Please select the image")
            isReady = false
            return isReady
        }
        return isReady
    }
    
    
    public func didDismiss() {
        guard let _ =  self.snapImage else {
            return
        }
        self.snapImage = nil
        self.hidingShareButton = false
        
        DispatchQueue.main.async {
            self.pubSnapImageLastUpdated = Date().timeIntervalSince1970
            self.pubSnapImageReady = false
        }
    }
}
