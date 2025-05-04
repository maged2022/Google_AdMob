//
//  ContentView.swift
//  Google_AdMob
//
//  Created by maged on 02/05/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var rewardAdViewModel = RewardAdViewModel(adService: RewardedService())
    @StateObject private var interstitialVM = InterstitialAdViewModel(adService: InterstitialService())
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                VStack {
                    Text("Reward Example")
                        .font(.title2)
                        .bold()
                    
                    RewardAdButton(viewModel: rewardAdViewModel, onReward: {
                        // Rewarded here
                        print("Prize from Rewarded Add...")
                    }) {
                        HStack {
                            Image(systemName: "gift.fill") // You can also use a custom asset
                                .foregroundColor(.blue)
                            
                            Text("Watch Ad to Earn 500MB")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(rewardAdViewModel.isAdReady ? Color.blue.opacity(0.4) : Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                }
                .padding(.top)
                Divider()
                    .frame(height: 1)
                    .background(.black)
                    
                
                VStack {
                    Text("Interstitial Example")
                        .font(.title2)
                        .bold()
                    InterstitialAdButton(viewModel: interstitialVM)
                }
                
                Spacer()
                
                VStack {
                    Text("Banner Example")
                        .font(.title2)
                        .bold()
                    ResponsiveBannerAdView(adUnitID: AdConfig.bannerUnitID)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .navigationTitle("Google AdMob")
        }
    }
}
#Preview {
    ContentView()
}
