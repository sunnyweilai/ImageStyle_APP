//
//  SwiftUIExtension.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-08.
//

import Foundation
import SwiftUI
import UIKit

struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?
    var titleColor: UIColor?

    init(backgroundColor: UIColor?, buttonColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        
        coloredAppearance.titleTextAttributes = [.font : UIFont(name: "Rasa-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .black)]
        
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = buttonColor
    }

    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {

    func navigationBarColor(backgroundColor: UIColor?, buttonColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor,
                                            buttonColor: buttonColor))
    }
    static var primaryBackgroundColor: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [Color(hex: "#FEA2A2"), Color(hex: "#E5CF7E")]), startPoint: .top, endPoint: .bottom)
    }
}


extension Font {
    static var primaryFont: Font {
            return Font.custom("Rasa-Bold", size: 17)
        }
    static var secondaryFont: Font {
            return Font.custom("Rasa-Bold", size: 15)
        }
    static var hintFont:Font {
        return Font.custom("Rasa-Regular", size: 17)
    }
}





