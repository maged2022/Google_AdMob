//
//  RewardAdButton.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import SwiftUI

struct RewardAdButton<Content: View>: View {
    @ObservedObject var viewModel: RewardAdViewModel
    let content: () -> Content
    let onReward: () -> Void // 👈 New: Closure passed from HomeView

    init(viewModel: RewardAdViewModel, onReward: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.onReward = onReward
        self.content = content
    }

    var body: some View {
        Button(action: {
            if let vc = UIApplication.shared.rootViewController {
                viewModel.showAd(from: vc, onReward: onReward) // 👈 Pass it to ViewModel
            }
        }) {
            content()
        }
        .disabled(!viewModel.isAdReady)
    }
}

//#Preview {
//    RewardAdButton(viewModel: Re)
//}
