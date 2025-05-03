//
//  AdMobInterstitialService.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import GoogleMobileAds
import Combine

protocol InterstitialServiceProtocol {
    var isAdReadyPublisher: AnyPublisher<Bool, Never> { get }
    var adDismissedPublisher: AnyPublisher<Void, Never> { get }
    func loadAd()
    func showAd(from viewController: UIViewController)
}

final class InterstitialService: NSObject, InterstitialServiceProtocol {
    private var interstitialAd: InterstitialAd?
    private let adUnitID: String
    private let isReadySubject = CurrentValueSubject<Bool, Never>(false)
    private let adDismissedSubject = PassthroughSubject<Void, Never>()

    var isAdReadyPublisher: AnyPublisher<Bool, Never> {
        isReadySubject.eraseToAnyPublisher()
    }

    var adDismissedPublisher: AnyPublisher<Void, Never> {
        adDismissedSubject.eraseToAnyPublisher()
    }

    init(adUnitID: String = AdConfig.interstitialUnitID) {
        self.adUnitID = adUnitID
        super.init()
        loadAd()
    }

    func loadAd() {
        InterstitialAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
            if let error = error {
                print("❌ Failed to load interstitial ad: \(error.localizedDescription)")
                self?.isReadySubject.send(false)
                return
            }

            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            self?.isReadySubject.send(true)
            print("✅ Interstitial ad is ready")
        }
    }

    func showAd(from viewController: UIViewController) {
        guard let ad = interstitialAd else {
            print("🚫 Interstitial ad not ready")
            adDismissedSubject.send()
            return
        }
        ad.present(from: viewController)
    }
}

extension InterstitialService: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        isReadySubject.send(false)
        interstitialAd = nil
        adDismissedSubject.send()
        loadAd()
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Interstitial failed to present: \(error.localizedDescription)")
        adDismissedSubject.send()
        loadAd()
    }
}
