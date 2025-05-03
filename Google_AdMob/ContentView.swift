//
//  ContentView.swift
//  Google_AdMob
//
//  Created by maged on 02/05/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack {
                
                VStack {
                    
                    Text("Reward Example")
                        .font(.title2)
                        .bold()
                    
                    RewardAdButton()
                }
                .padding(.top)
                .padding(.top)
                .padding(.top)
                Spacer()
                VStack {
                    
                    Text("Banner Example")
                        .font(.title2)
                        .bold()
                    BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716") // AdMob test banner
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical)
            }
            
            .padding()
            .navigationTitle("Google AdMob")
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



import GoogleMobileAds
import SwiftUI

class RewardedAdManager: NSObject, ObservableObject {
    private var rewardedAd: RewardedAd?
    @Published var isAdReady = false
    
    // Replace with your actual AdMob Rewarded Ad Unit ID
    let adUnitID = "ca-app-pub-3940256099942544/1712485313" // Test ID
    
    override init() {
        super.init()
        loadAd()
    }
    
    func loadAd() {
        let request = Request()
        // Correct method to load the RewardedAd
        RewardedAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("❌ Failed to load rewarded ad: \(error.localizedDescription)")
                self?.isAdReady = false
                return
            }
            
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.isAdReady = true
            print("✅ Rewarded ad is ready")
        }
    }
    
    func showAd(from rootViewController: UIViewController, onReward: @escaping () -> Void) {
        guard let ad = rewardedAd else {
            print("🚫 Ad not ready")
            return
        }
        
        // Correct method for presenting the RewardedAd
        ad.present(from: rootViewController) {
            let reward = ad.adReward
            print("🎁 User rewarded with: \(reward.amount) \(reward.type)")
            onReward()
        }
    }
    
  
}

// MARK: - FullScreenContentDelegate Methods
extension RewardedAdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("ℹ️ Ad dismissed")
        loadAd() // Reload for next time
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Ad failed to present: \(error.localizedDescription)")
        loadAd()
    }
}

struct RewardAdButton: View {
    @StateObject private var adManager = RewardedAdManager()
    
    var body: some View {
        Button("Watch Ad to Get Reward") {
            if let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
                .first {
                adManager.showAd(from: rootVC) {
                    // Handle the reward logic here
                    print("🎉 Reward granted to user!")
                }
            }
        }
        .disabled(!adManager.isAdReady)
        .padding()
        .background(adManager.isAdReady ? Color.green : Color.gray)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}
