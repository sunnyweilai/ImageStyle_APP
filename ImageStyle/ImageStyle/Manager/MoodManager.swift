//
//  DateManager.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-19.
//

import Foundation
import SwiftUI

class MoodManager: ObservableObject {
    
    /// this is the picked date to notify all the view
    @Published var pubDate = Date()
    
    /// this is used to trigger date picker sheet
    @Published var pubChangingDate = false
    
    static public var shared : MoodManager = {
        let date = MoodManager()
        return date
    }()
    
    public func didDatePickerDismissed() {
        self.pubChangingDate = false

    }
    
    
}
