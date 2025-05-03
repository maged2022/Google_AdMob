//
//  LaunchScreenView.swift
//  Google_AdMob
//
//  Created by maged on 03/05/2025.
//

import SwiftUI

struct LaunchScreenView: View {
    @StateObject private var viewModel = LaunchViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAdFinished {
                ContentView()
            } else {
                VStack(spacing: 20) {
                    ProgressView()
                    Text("Loading...")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
        }
        .animation(.easeInOut, value: viewModel.isAdFinished)
    }
}
