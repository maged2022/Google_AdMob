//
//  InterstitialAdButton.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import SwiftUI

struct InterstitialAdButton: View {
    @ObservedObject var viewModel: InterstitialAdViewModel
    
    var body: some View {
        Button("Show Interstitial Ad") {
            if let rootVC = UIApplication.shared.rootViewController {
                viewModel.showAdIfReady(from: rootVC)
            }
        }
        .disabled(!viewModel.isAdReady)
        .padding()
        .background(viewModel.isAdReady ? Color.blue : Color.gray)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}
