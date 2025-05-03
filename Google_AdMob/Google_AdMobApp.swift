//
//  Google_AdMobApp.swift
//  Google_AdMob
//
//  Created by maged on 02/05/2025.
//

import SwiftUI
import GoogleMobileAds

@main
struct Google_AdMobApp: App {
    
    init() {
        MobileAds.shared.start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
        }
    }
}
