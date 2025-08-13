//
//  TabContentFactory.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Tab Content Factory

/// Factory for creating tab content views
/// Simplifies MainView and improves separation of concerns
struct TabContentFactory {
    
    @ViewBuilder
    static func makeTabView(
        for tab: MainTab,
        viewModel: MainViewModel
    ) -> some View {
        switch tab {
        case .home:
            HomeTabView(viewModel: viewModel.homeViewModel)
        case .search:
            SearchTabView(viewModel: viewModel.searchViewModel)
        case .ai:
            AIChatTabView(viewModel: viewModel.aiChatViewModel)
        case .library:
            LibraryTabView(viewModel: viewModel.libraryViewModel)
        case .profile:
            ProfileTabView(viewModel: viewModel.profileViewModel)
        }
    }
}

// MARK: - Tab View Protocol

/// Protocol for consistent tab view implementation
protocol TabViewProtocol: View {
    associatedtype ViewModel: ObservableObject
    var viewModel: ViewModel { get }
}