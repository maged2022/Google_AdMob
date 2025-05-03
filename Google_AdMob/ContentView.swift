//
//  ContentView.swift
//  Google_AdMob
//
//  Created by maged on 02/05/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var rewardVM = RewardAdViewModel(adService: RewardedService())
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                VStack {
                    Text("Reward Example")
                        .font(.title2)
                        .bold()
                    RewardAdButton(viewModel: rewardVM)
                }
                
                Spacer()
                
                VStack {
                    Text("Banner Example")
                        .font(.title2)
                        .bold()
                    BannerAdView(adUnitID: AdConstant.bannerUnitID)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .navigationTitle("Google AdMob")
        }
    }
}
