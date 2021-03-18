//
//  ImageSaver.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-01-21.
//

import UIKit

class ImageSaver: NSObject{
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError),nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print ("\(error.localizedDescription)")
        } else{
            print("success!")
            
            //dismiss snapimage sheet
            ImageManager.shared.didDismiss()
        }
    }
}
