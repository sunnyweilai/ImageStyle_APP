//
//  ImageStyleApp.swift
//  ImageStyle
//
//  Created by sunnywei on 2021-01-05.
//

import SwiftUI

@main
struct ImageStyleApp: App {
    var body: some Scene {
        WindowGroup {
            TabView{
            ImageTransferStyleView().tabItem {
                Image(systemName: "wand.and.stars")
                Text("Style Transfer")
            }
            ImageFilterStyleView().tabItem {
                Image(systemName: "slider.vertical.3")
                Text("Style Edit")
            }
            }
        }
    }
}
