//
//  AdMobRewardedService.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import UIKit
import Combine

protocol RewardedAdServiceDelegate {
    var isAdReadyPublisher: AnyPublisher<Bool, Never> { get }
    func loadAd()
    func showAd(from viewController: UIViewController, onReward: @escaping () -> Void)
}


import GoogleMobileAds
import Combine

final class RewardedService: NSObject, RewardedAdServiceDelegate {
    private var rewardedAd: RewardedAd?
    private var rewardHandler: (() -> Void)?
    
    private let adUnitID: String
    private let isAdReadySubject = CurrentValueSubject<Bool, Never>(false)
    
    var isAdReadyPublisher: AnyPublisher<Bool, Never> {
        isAdReadySubject.eraseToAnyPublisher()
    }
    
    init(adUnitID: String = AdConstant.rewardedUnitID) {
        self.adUnitID = adUnitID
        super.init()
        loadAd()
    }
    
    func loadAd() {
        RewardedAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
            if let error = error {
                print("❌ Failed to load rewarded ad: \(error.localizedDescription)")
                self?.isAdReadySubject.send(false)
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.isAdReadySubject.send(true)
            print("✅ Rewarded ad loaded")
        }
    }
    
    func showAd(from viewController: UIViewController, onReward: @escaping () -> Void) {
        guard let ad = rewardedAd else {
            print("🚫 Ad not ready")
            return
        }
        rewardHandler = onReward
        ad.present(from: viewController) { [weak self] in
            print("🎁 User rewarded with: \(ad.adReward.amount) \(ad.adReward.type)")
            self?.rewardHandler?()
        }
    }
}

extension RewardedService: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("ℹ️ Ad dismissed, reloading")
        loadAd()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Failed to present ad: \(error.localizedDescription)")
        loadAd()
    }
}
