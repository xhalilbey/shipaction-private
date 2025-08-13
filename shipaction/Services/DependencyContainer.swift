//
//  DependencyContainer.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import Observation

// MARK: - Dependency Container Protocol

/// Protocol defining the dependency container interface for better testability
protocol DependencyContainerProtocol {
    var userRepository: UserRepository { get }
    var authenticationService: AuthenticationService { get }
    var navigationManager: NavigationManager { get }
    var networkManager: NetworkMonitoring { get }
    var loggingService: LoggingServiceProtocol { get }
    
    func makeAuthenticationViewModel() -> AuthenticationViewModel
    func makeMainViewModel() -> MainViewModel
    func makeOnboardingViewModel() -> OnboardingViewModel
    func makeProfileViewModel() -> ProfileViewModel
    func makeAppStartupViewModel() -> AppStartupViewModel
    func makeHomeViewModel() -> HomeViewModel
    func makeSearchViewModel() -> SearchViewModel
    func makeAIChatViewModel() -> AIChatViewModel
    func makeLibraryViewModel() -> LibraryViewModel
}

// MARK: - Dependency Container

/// Central dependency injection container for the application
/// 
/// Provides a single source of truth for all app dependencies
/// Following 2024 iOS dependency injection best practices with protocol-based design
@Observable
final class DependencyContainer: DependencyContainerProtocol {
    
    // MARK: - Dependencies
    
    let navigationManager: NavigationManager
    let networkManager: NetworkMonitoring
    let loggingService: LoggingServiceProtocol
    
    // MARK: - Core Services
    
    let userRepository: UserRepository
    let securityManager: SecurityManaging
    let authenticationService: AuthenticationService
    
    // MARK: - ViewModels
    
    func makeAuthenticationViewModel() -> AuthenticationViewModel {
        return AuthenticationViewModel(
            authenticationService: authenticationService,
            navigationManager: navigationManager
        )
    }
    
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel(
            authenticationService: authenticationService,
            userRepository: userRepository,
            navigationManager: navigationManager,
            loggingService: loggingService,
            homeViewModel: makeHomeViewModel(),
            searchViewModel: makeSearchViewModel(),
            aiChatViewModel: makeAIChatViewModel(),
            libraryViewModel: makeLibraryViewModel(),
            profileViewModel: makeProfileViewModel()
        )
    }
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        return OnboardingViewModel(
            navigationManager: navigationManager,
            userRepository: userRepository
        )
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(
            authenticationService: authenticationService,
            userRepository: userRepository,
            navigationManager: navigationManager
        )
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel()
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel()
    }
    
    func makeAIChatViewModel() -> AIChatViewModel {
        return AIChatViewModel()
    }
    
    func makeLibraryViewModel() -> LibraryViewModel {
        return LibraryViewModel(userRepository: userRepository)
    }
    
    func makeAppStartupViewModel() -> AppStartupViewModel {
        return AppStartupViewModel(
            navigationManager: navigationManager,
            userRepository: userRepository,
            networkManager: networkManager,
            loggingService: loggingService
        )
    }
    
    // MARK: - Initialization
    
    init(
        navigationManager: NavigationManager,
        networkManager: NetworkMonitoring = NetworkManager.shared,
        loggingService: LoggingServiceProtocol = LoggingService.shared
    ) {
        self.navigationManager = navigationManager
        self.networkManager = networkManager
        self.loggingService = loggingService
        self.userRepository = LiveUserRepository()
        self.securityManager = SecurityManager()
        self.authenticationService = LiveAuthenticationService(
            userRepository: userRepository,
            securityManager: securityManager,
            networkManager: networkManager,
            loggingService: loggingService
        )
    }
}