//
//  ImageStyleApp.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-01-05.
//

import SwiftUI

@main
struct ImageStyleApp: App {
    let coreDataManager = CoreDataManager.shared
    @ObservedObject var alert = AlertController.shared
    @ObservedObject var image = ImageManager.shared
    let startColor = "#FEA2A2"
    let endColor = "#E5CF7E"
    init() {
        UITextView.appearance().backgroundColor = .white
        UITextView.appearance().textContainerInset =
            UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ImageTransferStyleView()
            }
            .environment(\.managedObjectContext, coreDataManager.container.viewContext)
            .navigationBarColor(backgroundColor: UIColor(hex: startColor), buttonColor: .white)
            .alert(isPresented: self.$alert.presentAlert){ () -> Alert in
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
