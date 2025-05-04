//
//  RewardAdViewModel.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import Combine
import UIKit

final class RewardAdViewModel: ObservableObject {
    @Published var isAdReady: Bool = false
    
    private let adService: RewardedAdServiceDelegate
    private var cancellables = Set<AnyCancellable>()
    
    init(adService: RewardedAdServiceDelegate) {
        self.adService = adService
        observeAdAvailability()
    }
    
    func showAd(from viewController: UIViewController, onReward: @escaping () -> Void) {
        adService.showAd(from: viewController) {
            print("🎉 Reward granted")
            onReward() // 👈 This gets called when the user finishes watching the ad
        }
    }
    
    private func observeAdAvailability() {
        adService.isAdReadyPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isAdReady)
    }
}
