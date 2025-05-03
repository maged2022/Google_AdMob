//
//  AdMobInterstitialService.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import GoogleMobileAds
import Combine

final class AdMobInterstitialService: NSObject, ObservableObject {
    private var interstitialAd: InterstitialAd?
    private var isReadySubject = CurrentValueSubject<Bool, Never>(false)
    private let adUnitID: String
    
    var isAdReadyPublisher: AnyPublisher<Bool, Never> {
        isReadySubject.eraseToAnyPublisher()
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
            return
        }
        
        ad.present(from: viewController)
    }
}

extension AdMobInterstitialService: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("ℹ️ Interstitial dismissed, loading next")
        loadAd()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Failed to present interstitial: \(error.localizedDescription)")
        loadAd()
    }
}
