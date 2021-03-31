//
//  ToastView.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-30.
//

import SwiftUI

struct ToastView: View {
    @ObservedObject var toast = ToastManager.shared
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text(toast.message).font(.primaryFont)
                Spacer()
            }.padding(10)
        }.frame(minWidth: 100, maxWidth: 300, minHeight: 70, alignment: .center).background(Color.white).cornerRadius(10)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView()
    }
}
