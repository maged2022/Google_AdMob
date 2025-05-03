//
//  RewardAdButton.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import SwiftUI

struct RewardAdButton: View {
    @ObservedObject var viewModel: RewardAdViewModel
    
    var body: some View {
        Button("Watch Ad to Get Reward") {
            if let vc = UIApplication.shared.rootViewController {
                viewModel.showAd(from: vc)
            }
        }
        .disabled(!viewModel.isAdReady)
        .padding()
        .background(viewModel.isAdReady ? Color.green : Color.gray)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}


//#Preview {
//    RewardAdButton(viewModel: Re)
//}
