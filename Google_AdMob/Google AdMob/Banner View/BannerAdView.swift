//
//  BannerAdView.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    var adUnitID: String

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSize(size: CGSize(width: 320, height: 50), flags: 0))
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.rootViewController
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        // No updates needed
    }
}


extension UIApplication {
    var rootViewController: UIViewController? {
        connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
            .first
    }
}

