//
//  LanuchViewModel.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import Combine
import SwiftUI

final class LaunchViewModel: ObservableObject {
    @Published var isAdFinished = false
    
    private let adService = InterstitialService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Show ad when it's ready
        adService.isAdReadyPublisher
            .filter { $0 }
            .first()
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.presentAd()
                }
            }
            .store(in: &cancellables)
        
        // Handle ad dismissal
        adService.adDismissedPublisher
            .sink { [weak self] in
                DispatchQueue.main.async {
                    self?.isAdFinished = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func presentAd() {
        guard let rootVC = UIApplication.shared.rootViewController else {
            isAdFinished = true
            return
        }
        adService.showAd(from: rootVC)
    }
}
