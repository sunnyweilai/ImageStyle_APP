//
//  ImageMLFilterView.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-04.
//

import SwiftUI

struct ImageMLFilterView: View {
    let filterArray = [1,2,3]
    var body: some View {
        GeometryReader{ geo in
            ScrollView(.horizontal, showsIndicators: false){
        HStack{
            ForEach(filterArray, id: \.self){ item in
                SingleMLFilterView()
            }
        }
        }.frame(height: 170, alignment: .leading)
        }
    }
}

struct SingleMLFilterView: View {
    
    var body: some View {
        Button (action:
                    {
                        print("apply")
                    }){
            VStack{
                Spacer()
                Text("Korean").foregroundColor(.black)
                Spacer().frame(height: 5)
                Image("style1")
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
