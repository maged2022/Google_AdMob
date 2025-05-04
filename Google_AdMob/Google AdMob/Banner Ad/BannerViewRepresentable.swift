//
//  BannerAdView.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String
    let width: CGFloat
    
    static func calculatedHeight(for width: CGFloat) -> CGFloat {
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        return adSize.size.height
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> BannerView {
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        let bannerView = BannerView(adSize: adSize)
        bannerView.adUnitID = adUnitID
        bannerView.delegate = context.coordinator
        bannerView.rootViewController = context.coordinator.topViewController()
        bannerView.load(Request())
        return bannerView
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        let newSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        if !isAdSizeEqualToSize(size1: uiView.adSize,size2: newSize) {
            uiView.adSize = newSize
            uiView.load(Request())
        }
    }
    
    class Coordinator: NSObject, BannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("[AdMob] ✅ Banner loaded successfully")
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("[AdMob] ❌ Failed to load banner: \(error.localizedDescription)")
        }
        
        func topViewController(base: UIViewController? = nil) -> UIViewController? {
            let base = base ?? UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.windows.first(where: \.isKeyWindow)?.rootViewController }
                .first
            if let nav = base as? UINavigationController {
                return topViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                return topViewController(base: tab.selectedViewController)
            }
            if let presented = base?.presentedViewController {
                return topViewController(base: presented)
            }
            return base
        }
    }
}


import SwiftUI

struct ResponsiveBannerAdView: View {
    let adUnitID: String
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = BannerAdView.calculatedHeight(for: width)
            
            BannerAdView(adUnitID: adUnitID, width: width)
                .frame(width: width, height: height)
        }
        .frame(height: BannerAdView.calculatedHeight(for: UIScreen.main.bounds.width))
    }
}


extension UIApplication {
    var rootViewController: UIViewController? {
        connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
            .first
    }
}

