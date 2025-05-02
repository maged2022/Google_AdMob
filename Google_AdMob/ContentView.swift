//
//  ContentView.swift
//  Google_AdMob
//
//  Created by maged on 02/05/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("VPN App Home")
                .font(.title)
            Spacer()
            BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716") // AdMob test banner
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    var adUnitID: String

    func makeUIView(context: Context) -> BannerView {
        // ✅ Create AdSize with UInt flag = 0
        let adSize = AdSize(size: CGSize(width: 320, height: 50), flags: 0)
        let bannerView = BannerView(adSize: adSize)
        bannerView.adUnitID = adUnitID

        // ✅ Set rootViewController
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first {
            bannerView.rootViewController = rootViewController
        }

        // ✅ Load ad
        bannerView.load(Request())
        return bannerView
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        // No updates needed
    }
}
