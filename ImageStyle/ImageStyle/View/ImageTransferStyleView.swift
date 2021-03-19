//
//  HomeView.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-01-22.
//

import SwiftUI

struct ImageTransferStyleView: View {
    @State private var contentImage: Image?
    
    @State private var pickedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var imageIsReady = false
    
    @ObservedObject var image = ImageManager.shared
    @ObservedObject var model = ModelManager.shared
    @ObservedObject var mood = MoodManager.shared
    
    @State var constrastState: Double = 1
    @State var brightnessState: Double = 0
    @State var saturationState: Double = 1
    @State var currentDate = Date()
    let startColor = "#FEA2A2"
    let endColor = "#E5CF7E"
    
    init() {
        
    }
    var body: some View {
        let styledImage = model.styledImage
        
        return 
            GeometryReader{ geo in
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10).fill(Color.white).opacity(0.4).frame(height: geo.size.height / 2)
                        if styledImage != nil || pickedImage != nil {
                            Image(uiImage: (styledImage == nil ? pickedImage : styledImage) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(height: geo.size.height / 2)
                                .brightness(brightnessState)
                                .contrast(constrastState)
                                .saturation(saturationState)
                        }else{
                                
                            VStack{
                                Image(systemName: "plus").renderingMode(.template).imageScale(.large)
                                Text("Tap to select your image")
                                    .font(.primaryFont)
                                    
                            } .foregroundColor(.white)
                        }
                        
                        
                        
                    }.onTapGesture {
                        self.showingImagePicker = true
                    }
                    
                    Spacer()
                   
                    TabView{
                        
                        ImageMLFilterView(inputImage: pickedImage).frame(alignment: .leading)
                            .tabItem{
                                Image(systemName: "wand.and.stars")
                                Text("Style")}.padding(.leading, 10).background(Color(hex: endColor))
                        ImageEditView(constrastState: $constrastState, brightnessState: $brightnessState, saturationState: $saturationState).tabItem{
                            Image(systemName: "slider.vertical.3")
                            Text("Edit")}.padding(.horizontal, 10).background(Color(hex: endColor))
                    }
                    .onAppear() {
                        
                        UITabBar.appearance().barTintColor = UIColor(hex: endColor)
                        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: "Rasa-Regular", size: 12)! ], for: .normal)
                        UITabBar.appearance().clipsToBounds = true
                        UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
                       
                        
                    }
                    .accentColor(.black)
                    .frame(height: 250).clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                    
                    NavigationLink(destination: MoodView(pickedImage: Image(uiImage: (styledImage == nil ? pickedImage : styledImage) ?? UIImage())), isActive: $imageIsReady){ EmptyView() }
                    
                }.padding([.horizontal, .bottom])
                
                .navigationBarItems(trailing: Button("Next"){
                    imageIsReady = self.image.ImagesAreReady(contentImage)
                    
                })
                .navigationBarTitle(Text(""), displayMode: .inline)
                
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                    ImagePicker(image: self.$pickedImage)
                }
                
            }.background(Color.primaryBackgroundColor)
        
        
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

struct ImageEditView: View {
    @Binding var constrastState: Double
    @Binding var brightnessState: Double
    @Binding var saturationState: Double
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text("Constrast").font(.secondaryFont)
                Slider(value: $constrastState, in: 0...1).accentColor(.white)
            }
            Spacer()
            HStack{
                Text("Brightness").font(.secondaryFont)
                Slider(value: $brightnessState, in: 0...1).accentColor(.white)
            }
            Spacer()
            HStack{
                Text("Saturation").font(.secondaryFont)
                Slider(value: $saturationState, in: 0...1).accentColor(.white)
            }
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTransferStyleView()
    }
}
