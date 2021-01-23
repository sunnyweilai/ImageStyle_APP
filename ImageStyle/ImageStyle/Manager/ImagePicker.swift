//
//  ImagePicker.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-01-05.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    
   /// let us control how the coordinator is made
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// swiftUI handle the delegate classes by letting us define a coordinator that belongs to the struct
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        /// we need to create it with a reference to the image picker that owns it, so the coordinator can forward on interesting events.
        let parent: ImagePicker
        
        init(_ parent: ImagePicker){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage{
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>){
    }
    
    
}


