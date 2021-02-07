//
//  ImageStyleApp.swift
//  ImageStyle
//
//  Created by sunnywei on 2021-01-05.
//

import SwiftUI

@main
struct ImageStyleApp: App {
    @ObservedObject var alert = AlertController.shared
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
            }.alert(isPresented: self.$alert.presentAlert){ () -> Alert in
                if self.alert.type == .confirm {
                    return Alert(title: Text(alert.title ?? ""), message: Text(alert.message), primaryButton: Alert.Button.default(Text(alert.confirmButtonText), action: {
                        self.alert.confirm?()
                    }), secondaryButton: Alert.Button.cancel(Text(alert.cancelButtonText), action: {
                        self.alert.cancel?()
                    }))
                }
                return Alert(title: Text(alert.title ?? ""), message: Text(alert.message), dismissButton: .default(Text("OK")))
        }
        }
    }
}
