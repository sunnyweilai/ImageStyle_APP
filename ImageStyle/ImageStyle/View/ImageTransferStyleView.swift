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
    
    @State var constrastState: Double = 1
    @State var brightnessState: Double = 0
    @State var saturationState: Double = 1
    
    let startColor = "#FEA2A2"
    let endColor = "#E5CF7E"
    
    init() {
        
    }
    var body: some View {
        let styledImage = model.styledImage
        
        return NavigationView{
            GeometryReader{ geo in
                VStack{
                    ZStack{
                        if styledImage != nil {
                            Image(uiImage: styledImage!)
                                .resizable()
                                .scaledToFit()
                                .brightness(brightnessState)
                                .contrast(constrastState)
                                .saturation(saturationState)
                        }else{
                            if contentImage != nil{
                                contentImage?
                                    .resizable()
                                    .scaledToFit()
                                    .brightness(brightnessState)
                                    .contrast(constrastState)
                                    .saturation(saturationState)
                            }
                            else{
                                RoundedRectangle(cornerRadius: 10).fill(Color.white).opacity(0.4).frame(height: geo.size.height / 2)
                                Text("Tap to select your content picture")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                        }
                        
                        
                        
                    }.onTapGesture {
                        self.showingImagePicker = true
                    }
                    
                    Spacer()
                   
                    TabView{
                        
                        ImageMLFilterView(inputImage: pickedImage).frame(alignment: .leading).tabItem{Text("Style")}.padding(.leading, 10).background(Color(hex: endColor))
                        ImageEditView(constrastState: $constrastState, brightnessState: $brightnessState, saturationState: $saturationState).tabItem{Text("Edit")}.padding(.horizontal, 10).background(Color(hex: endColor))
                    }.onAppear() {
                        
                        UITabBar.appearance().barTintColor = UIColor(hex: endColor)
                       
                        
                    }
                    .accentColor(.black)
                    .frame(height: 250).clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                    
                    NavigationLink(destination: MoodView(), isActive: $imageIsReady){ EmptyView() }
                    
                }.padding([.horizontal, .bottom])
                
                .navigationBarItems(trailing: Button("Next"){
                    imageIsReady = self.image.ImagesAreReady(contentImage)
                    
                })
                .navigationBarTitle(Text(""), displayMode: .inline)
                
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                    ImagePicker(image: self.$pickedImage)
                }
                
            }.background(LinearGradient(gradient: Gradient(colors: [Color(hex: startColor), Color(hex: endColor)]), startPoint: .top, endPoint: .bottom))
        }.navigationBarColor(backgroundColor: UIColor(hex: startColor), titleColor: .white)
        
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
                Text("Constrast")
                Slider(value: $constrastState, in: 0...1).accentColor(.white)
            }
            Spacer()
            HStack{
                Text("Brightness")
                Slider(value: $brightnessState, in: 0...1).accentColor(.white)
            }
            Spacer()
            HStack{
                Text("Saturation")
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
