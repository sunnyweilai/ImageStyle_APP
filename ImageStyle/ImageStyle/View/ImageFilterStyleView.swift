//
//  ContentView.swift
//  ImageStyle
//
//  Created by lai wei on 2021-01-05.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageFilterStyleView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilterSheet = false
    
    @State private var processedImage: UIImage?
    let context = CIContext()
    var body: some View {
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            }, set: {
                self.filterIntensity = $0
                self.applyProcessing()
            })
        return NavigationView{
            VStack{
                ZStack{
                    if image != nil{
                        image?.resizable()
                            .scaledToFit()
                    }else{
                        Rectangle().fill(Color.white).opacity(0.4)
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }.onTapGesture {
                    self.showingImagePicker = true
                }
                
                HStack{
                    Text("Intensity")
                    Slider(value: intensity)
                }.padding(.vertical)
                
                HStack{
                    Button("Change Filter"){
                        self.showingFilterSheet = true
                    }.actionSheet(isPresented: $showingFilterSheet) {
                        ActionSheet(title: Text("Select a filter"), buttons: [
                            .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize()) },
                                .default(Text("Edges")) { self.setFilter(CIFilter.edges()) },
                                .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur()) },
                                .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate()) },
                                .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone()) },
                                .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask()) },
                                .default(Text("Vignette")) { self.setFilter(CIFilter.vignette()) },
                                .cancel()
                        ])
                            }
                    
                    Spacer()
                    
                    Button("Save"){
                        guard let processedImage = self.processedImage else {
                            return
                        }
                        
                    let imageSaver = ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Edit")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                ImagePicker(image: self.$inputImage)
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else{
            return
        }
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey){currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey){currentFilter.setValue(filterIntensity, forKey: kCIInputRadiusKey
        )}
        
        if inputKeys.contains(kCIInputScaleKey){currentFilter.setValue(filterIntensity, forKey: kCIInputScaleKey
        )}
        
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent){
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImageFilterStyleView()
    }
}
