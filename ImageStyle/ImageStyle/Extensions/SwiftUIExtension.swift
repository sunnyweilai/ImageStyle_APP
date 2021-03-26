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
    
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        guard let view = controller.view else {
            return UIImage()
        }
        
        let targetSize = controller.view.intrinsicContentSize
        view.bounds = CGRect(origin: .zero, size: targetSize)
        view.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.bounds = CGRect(origin: .zero, size: targetSize)
        let backgroundLayer = CAGradientLayer()
        backgroundLayer.frame = controller.view.bounds
        backgroundLayer.colors = [UIColor(hex: "#FEA2A2").cgColor, UIColor(hex: "#E5CF7E").cgColor]
        
        backgroundView.layer.addSublayer(backgroundLayer)
        backgroundView.addSubview(view)
        view.center = backgroundView.center
        
        return renderer.image{ _ in
            
                backgroundView.drawHierarchy(in: backgroundView.bounds, afterScreenUpdates: true)
                // show the sheet
                ImageManager.shared.pubSnapImageReady
                    = true
            }
    }
}



extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    static var dateAndMonth: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM,d"
        return formatter
    }
    
    static var dateAndMonthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d yyyy"
        return formatter
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
    static var titleFont:Font {
        return Font.custom("Rasa-Bold", size: 20)
    }
}





