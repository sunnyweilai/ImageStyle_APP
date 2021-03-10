//
//  ImageMLFilterView.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-04.
//

import SwiftUI

struct ImageMLFilterView: View {
    var inputImage: UIImage?
    let filterArray: [StyleModelType] = [.koreanStyle,.peachBlushStyle]
    var body: some View {
        GeometryReader{ geo in
            ScrollView(.horizontal, showsIndicators: false){
        HStack{
            ForEach(filterArray, id: \.self){ item in
                SingleMLFilterView(inputImage: inputImage, styleModel: item)
            }
        }
        }.frame(height: 170, alignment: .leading)
        }.background(Color.clear)
    }
}

struct SingleMLFilterView: View {
    @ObservedObject var model = ModelManager.shared
    var inputImage: UIImage?
    var styleModel: StyleModelType
    var body: some View {
        Button (action:
                    {
                        guard let input = inputImage else {return}
                        ModelManager.applyStyle(inputImage: input, style: styleModel)
                        
                    }){
            VStack{
                Spacer()
                Text("\(styleModel.toFilterName())")
                    .font(.secondaryFont)
                Spacer().frame(height: 5)
                Image("\(styleModel.rawValue)Template")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 130, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
        }

    }
}

struct ImageMLFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ImageMLFilterView()
    }
}
