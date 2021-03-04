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
        GeometryReader{ geo in
        NavigationView{
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color.secondary).frame(height: geo.size.height / 2)
                    
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
                VStack{
                    Spacer()
                    ImageMLFilterView().frame(height: 180, alignment: .leading)
                }
                
                
                //                ZStack{
                //                    Rectangle().fill(Color.secondary)
                //
                //                    if styleImage != nil{
                //                        styleImage?.resizable()
                //                            .scaledToFit()
                //                    }else{
                //                        Text("Tap to select your style picture")
                //                            .foregroundColor(.white)
                //                            .font(.headline)
                //                    }
                //                }.onTapGesture {
                //                    self.showingImagePicker = true
                //                }
            }.padding([.horizontal, .bottom])
            .navigationBarTitle("Edit")
            .navigationBarItems(trailing: Button("Next"){
                self.image.ImagesAreReady(contentImage, styleImage)
            })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                ImagePicker(image: self.$pickedImage)
            }
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
