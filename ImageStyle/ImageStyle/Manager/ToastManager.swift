//
//  ToastManager.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-30.
//
import Foundation
import SwiftUI

class ToastManager: ObservableObject {
    @Published var pubPresentToastView = false
    
    /// this is the message string on the view
    public var message: String = ""
    
    public static var shared: ToastManager = {
        let toast = ToastManager()
        return toast
    }()
    
    /// This is used to show the message for the toast in the app
    public static func show(message: String, delay: Double = 0.5, duration:Double = 2.5){
        shared.message = message
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation{
                shared.pubPresentToastView = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration){
                shared.hideToast()
            }
        }
    }
    
    /// This is used to automatically hide the toast in the app
    private func hideToast(){
        DispatchQueue.main.async {
            withAnimation{
                self.pubPresentToastView = false
            }
        }
    }
}
