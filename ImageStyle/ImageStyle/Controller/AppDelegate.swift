//
//  AppDelegate.swift
//  ADAY
//
//  Created by Lai Wei on 2021-04-17.
//

import Foundation
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
         registerForPushNotifications()
         return true
        }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert,.sound, .badge]){
                granted, _  in
                guard granted else {return }
                self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings{
            settings in
            print ("Notificaiton settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else {return}
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)          {
            let tokenParts = deviceToken.map{
                data in String(format: "%02.2hhx", data)
            }
            let token = tokenParts.joined()
            print("Device Token: \(token)")
       }
    
    
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
          print(error.localizedDescription)
       }
}
