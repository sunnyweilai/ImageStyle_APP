//
//  ImageManager.swift
//  ImageStyle
//
//  Created by sunnywei on 2021-01-23.
//

import Foundation
import SwiftUI
import UIKit

class ImageManager: NSObject, ObservableObject {
    
    override init() {}
    
    public static var shared: ImageManager = {
        let shared = ImageManager()
        return shared
    }()
    
    /// this is the content image displayed on the view
    @Published var pubContentImage: Data?
    
    /// this is used to verify if both images are selected to go to next step
    @Published var pubImagesAreReady = false
    
    /// this is used to verify if the share image is ready
    @Published var pubSnapImageReady = false
    
    @Published var pubSnapImageLastUpdated = Date().timeIntervalSince1970

    public var snapImage : UIImage?
    public var hidingShareButton = false
    
    public func ImagesAreReady(_ contentImg: Data?) -> Bool{
        var isReady = true
        guard let  _ = contentImg else {
            AlertController.presentAlert(title: nil, message: "Please select the image")
            isReady = false
            return isReady
        }
        return isReady
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError),nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print ("\(error.localizedDescription)")
        } else{
           
            ToastManager.show(message: "Your image is successfully saved \u{1F496}!")
            
            //dismiss snapimage sheet
            ImageManager.shared.didDismiss()
        }
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
