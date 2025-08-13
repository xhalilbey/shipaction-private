//
//  ContentView.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI

// MARK: - Content View

/// Root navigation view with clean startup management
/// 
/// Uses AppStartupViewModel to handle all initialization logic
/// keeping the view declarative and focused on presentation
struct ContentView: View {
    
    // MARK: - Environment & State
    
    @Environment(DependencyContainer.self) private var dependencies
    @State private var startupViewModel: AppStartupViewModel?
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if let viewModel = startupViewModel {
                switch viewModel.currentState {
                case .initializing, .loadingUserData, .checkingConnectivity:
                    LoadingView()
                        .transition(.opacity)
                
                case .noInternet:
                    NoInternetView(onRetry: {
                        Task { @MainActor in
                            await startupViewModel?.performStartup()
                        }
                    })
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom),
                            removal: .move(edge: .top)
                        ))
                
                case .ready(let flow):
                    switch flow {
                    case .onboarding:
                        OnboardingView(viewModel: dependencies.makeOnboardingViewModel())
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                    
                    case .main:
                        MainView(viewModel: dependencies.makeMainViewModel())
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                    }
                }
            } else {
                LoadingView()
            }
        }
        .animation(
            .easeInOut(duration: AppConstants.Animation.transitionDuration),
            value: startupViewModel?.currentFlow
        )
        .animation(
            .easeInOut(duration: 0.5),
            value: dependencies.networkManager.isConnected
        )
        .task {
            if startupViewModel == nil {
                startupViewModel = dependencies.makeAppStartupViewModel()
                await startupViewModel?.performStartup()
            }
        }
        .onChange(of: dependencies.networkManager.isConnected) { _, _ in
            startupViewModel?.handleConnectivityChange()
        }
    }

}

// MARK: - Preview
#Preview {
    let navigationManager = NavigationManager()
    let dependencies = DependencyContainer(navigationManager: navigationManager)
    
    return ContentView()
        .environment(navigationManager)
        .environment(dependencies)
}
