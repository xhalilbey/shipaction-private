//
//  MainView.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI

// MARK: - Main View

/// Main application interface with tab-based navigation following MVVM pattern.
/// 
/// Provides access to all major app sections through a modern tab bar.
/// Uses dependency injection for proper separation of concerns and follows
/// clean architecture principles with dedicated ViewModels for each section.
struct MainView: View {
    
    // MARK: - Properties
    
    /// ViewModel managing main interface state and tab navigation
    @State private var viewModel: MainViewModel
    
    // MARK: - Initialization
    
    init(viewModel: MainViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        StandardTabBarContainer(
            selectedTab: $viewModel.selectedTab,
            onSelectTab: { tab in viewModel.selectTab(tab) }
        ) {
            // Tab content based on selection with proper ViewModels
            ZStack {
                currentTabView
                    .animation(
                        .easeInOut(
                            duration: AppConstants.Animation.tabSelectionDuration
                        ),
                        value: viewModel.selectedTab
                    )
            }
        }
        .navigationBarHidden(true)
        .background(colorSchemeBackground)
        .task {
            // Load initial data through ViewModel
            await viewModel.loadInitialData()
        }
    }
    
    // MARK: - Computed Properties
    
    /// Returns the appropriate view for the currently selected tab
    @ViewBuilder
    private var currentTabView: some View {
        TabContentFactory.makeTabView(for: viewModel.selectedTab, viewModel: viewModel)
            .transition(tabTransition)
    }
    
    // MARK: - View Components
    
    /// Consistent transition animation for tab changes
    private var tabTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
    
    // MARK: - Background for color scheme
    private var colorSchemeBackground: Color { AppConstants.Colors.background }

}

// All tab view components are now in separate files

// MARK: - Preview

#Preview {
    let navigationManager = NavigationManager()
    let dependencies = DependencyContainer(navigationManager: navigationManager)
    
    return MainView(viewModel: dependencies.makeMainViewModel())
        .environment(navigationManager)
        .environment(dependencies)
}
