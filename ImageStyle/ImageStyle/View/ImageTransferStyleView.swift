//
//  HomeView.swift
//  ImageStyle
//
//  Created by sunnywei on 2021-01-22.
//

import SwiftUI

struct ImageTransferStyleView: View {
    @State private var contentImage: Image?
    
    @State private var pickedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var imageIsReady = false
    
    @ObservedObject var image = ImageManager.shared
    @ObservedObject var model = ModelManager.shared
    var body: some View {
        GeometryReader{ geo in
        NavigationView{
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color.secondary).frame(height: geo.size.height / 2)
                    
                    if model.styledImage != nil {
                        Image(uiImage: model.styledImage!).resizable()
                            .scaledToFit()
                    }else{
                    if contentImage != nil{
                        contentImage?.resizable()
                            .scaledToFit()
                        }
                    else{
                        Text("Tap to select your content picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    }
                }.onTapGesture {
                    self.showingImagePicker = true
                    
                }
                VStack{
                    Spacer()
                    ImageMLFilterView(inputImage: pickedImage).frame(height: 180, alignment: .leading)
                }
                NavigationLink(destination: MoodView(), isActive: $imageIsReady){ EmptyView() }
             
            }.padding([.horizontal, .bottom])
            .navigationBarTitle("Edit")
            .navigationBarItems(trailing: Button("Next"){
                imageIsReady = self.image.ImagesAreReady(contentImage)
                
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
            contentImage = inputImage
            model.styledImage = nil
      
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTransferStyleView()
    }
}
