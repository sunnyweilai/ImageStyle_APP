//
//  HomeView.swift
//  ImageStyle
//
//  Created by sunnywei on 2021-01-22.
//

import SwiftUI

struct ImageTransferStyleView: View {
    @State private var contentImage: Image?
    @State private var styleImage: Image?
    @State private var pickedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isContentImageSelected = false
    
    @State private var isReady = false
    
    @ObservedObject var image = ImageManager.shared
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Rectangle().fill(Color.secondary)
                    
                    if contentImage != nil{
                        contentImage?.resizable()
                            .scaledToFit()
                    }else{
                        Text("Tap to select your content picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }.onTapGesture {
                    self.showingImagePicker = true
                    self.isContentImageSelected = true
                }
                
                ZStack{
                    Rectangle().fill(Color.secondary)
                    
                    if styleImage != nil{
                        styleImage?.resizable()
                            .scaledToFit()
                    }else{
                        Text("Tap to select your style picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }.onTapGesture {
                    self.showingImagePicker = true
                }
            }.padding([.horizontal, .bottom])
            .navigationBarTitle("Edit")
            .navigationBarItems(
                                trailing:
                                    Button(action: {
                                            self.image.ImagesAreReady(contentImage, styleImage)
                                        
                                        
                                    }) {
                                        Text("Next")
                                    }
//                                    .alert(isPresented: $isReady) {
//                                        Alert(title: Text("Important message"), message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
//                                    }
                            )
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                ImagePicker(image: self.$pickedImage)
            }
        }
    }
    
    func loadImage() {
        guard let pickedImage = pickedImage else{
            return
        }
        let inputImage = Image(uiImage: pickedImage)
        if isContentImageSelected {
            contentImage = inputImage
            self.isContentImageSelected = false
        }else{
            styleImage = inputImage
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTransferStyleView()
    }
}
