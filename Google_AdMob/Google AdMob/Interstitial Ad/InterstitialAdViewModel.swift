//
//  InterstitialAdViewModel.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import Combine
import UIKit

final class InterstitialAdViewModel: ObservableObject {
    @Published var isAdReady = false
    private let adService: AdMobInterstitialService
    private var cancellables = Set<AnyCancellable>()
    
    init(adService: AdMobInterstitialService = AdMobInterstitialService()) {
        self.adService = adService
        bindAdState()
    }
    
    private func bindAdState() {
        adService.isAdReadyPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isAdReady)
    }
    
    func showAdIfReady(from viewController: UIViewController) {
        adService.showAd(from: viewController)
    }
}
