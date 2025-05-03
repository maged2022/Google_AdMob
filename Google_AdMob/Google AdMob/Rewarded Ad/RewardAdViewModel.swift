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
    
    func showAd(from viewController: UIViewController) {
        adService.showAd(from: viewController) {
            print("🎉 Reward granted")
            // ✅ Handle reward (e.g., give 500MB VPN credit)
        }
    }
    
    private func observeAdAvailability() {
        adService.isAdReadyPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isAdReady)
    }
}

