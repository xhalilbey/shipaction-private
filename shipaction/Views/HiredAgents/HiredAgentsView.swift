//
//  HiredAgentsView.swift
//  shipaction
//
//  Created by Assistant on 08.08.2025.
//

import SwiftUI

// MARK: - Hired Agents View

/// Modern table-style view for displaying hired agents with innovation focus
struct HiredAgentsView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = HiredAgentsViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    @State private var selectedSortOption: SortOption = .innovation
    @State private var searchText = ""
    @State private var showingFilters = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerSection
                
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.hiredAgents.isEmpty {
                    emptyStateView
                } else {
                    agentTableView
                }
            }
            .background(backgroundColor)
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.loadHiredAgents()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Navigation and Title
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(primaryTextColor)
                }
                
                Spacer()
                
                Text("Hired Agents")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(primaryTextColor)
                
                Spacer()
                
                // Stats button
                Button(action: { /* Show stats */ }) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(primaryTextColor)
                }
            }
                    .padding(.horizontal, AppConstants.UI.horizontalPadding)
        .padding(.top, 10)
            
            // Search and Filters
            HStack(spacing: 12) {
                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(secondaryTextColor)
                    
                    TextField("Search agents...", text: $searchText)
                        .font(.system(size: 16))
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                            .background(searchBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.smallCornerRadius))
                
                // Sort and filter button
                Button(action: { showingFilters.toggle() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.system(size: 14, weight: .medium))
                        Text("Sort")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(primaryTextColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(cardBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.smallCornerRadius))
                }
            }
            .padding(.horizontal, AppConstants.UI.horizontalPadding)
        }
        .padding(.bottom, AppConstants.UI.verticalPadding)
        .background(backgroundColor)
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
    
    // MARK: - Agent Table View
    
    private var agentTableView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Table Header
                tableHeaderView
                
                // Agent Rows
                ForEach(filteredAgents) { agent in
                    AgentRowView(agent: agent)
                }
            }
            .background(cardBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.largeCornerRadius))
            .padding(.horizontal, AppConstants.UI.horizontalPadding)
            .padding(.bottom, AppConstants.UI.verticalPadding)
        }
    }
    
    // MARK: - Table Header
    
    private var tableHeaderView: some View {
        HStack(spacing: 0) {
            // Agent Name - Expanded width
            HStack {
                Text("Agent")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(secondaryTextColor)
                Spacer()
            }
            .padding(.leading, 16)
            
            // Actions - Fixed width
            Text("Actions")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(secondaryTextColor)
                .frame(width: 100, alignment: .center)
                .padding(.trailing, 16)
        }
        .padding(.vertical, 14)
        .background(headerBackgroundColor)
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Loading hired agents...")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(secondaryTextColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            // Icon
                            ZStack {
                    Circle()
                        .fill(AppConstants.Colors.primary.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "briefcase.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(AppConstants.Colors.primary)
                }
            
            VStack(spacing: 8) {
                Text("No Hired Agents Yet")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(primaryTextColor)
                
                Text("Start by hiring your first AI agent to see them listed here")
                    .font(.system(size: 16))
                    .foregroundStyle(secondaryTextColor)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { dismiss() }) {
                Text("Browse Agents")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppConstants.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.buttonCornerRadius))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    // MARK: - Computed Properties
    
    private var filteredAgents: [HiredAgent] {
        var agents = viewModel.hiredAgents
        
        // Apply search filter
        if !searchText.isEmpty {
            agents = agents.filter { agent in
                agent.name.localizedCaseInsensitiveContains(searchText) ||
                agent.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply sorting
        switch selectedSortOption {
        case .innovation:
            agents = agents.sorted { $0.innovationScore > $1.innovationScore }
        case .tokenUsage:
            agents = agents.sorted { $0.tokenUsage > $1.tokenUsage }
        case .lastActive:
            agents = agents.sorted { $0.lastActiveDate > $1.lastActiveDate }
        case .alphabetical:
            agents = agents.sorted { $0.name < $1.name }
        }
        
        return agents
    }
}

// MARK: - Agent Row View

private struct AgentRowView: View {
    let agent: HiredAgent
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingMenu = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Agent Info - Expanded to take more space
            HStack(spacing: 12) {
                // Store Image Avatar
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 44, height: 44)
                    
                    Image("store")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(agent.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(primaryTextColor)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text(agent.category)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(secondaryTextColor)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer(minLength: 0)
            }
            .padding(.leading, 16)
            
            // Actions - Fixed width
            HStack(spacing: 8) {
                // Detail icon
                Button(action: { /* Show details */ }) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppConstants.Colors.turquoise)
                        .frame(width: 32, height: 32)
                        .background(AppConstants.Colors.turquoise.opacity(0.1))
                        .clipShape(Circle())
                }
                
                // Start/Launch icon
                Button(action: { /* Start agent */ }) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppConstants.Colors.turquoise)
                        .frame(width: 32, height: 32)
                        .background(AppConstants.Colors.turquoise.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .frame(width: 100, alignment: .center)
            .padding(.trailing, 16)
        }
        .padding(.vertical, 16)
        .background(cardBackgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppConstants.Colors.border.opacity(0.5), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var primaryTextColor: Color {
        AppConstants.Colors.dynamicPrimaryText(colorScheme)
    }
    
    private var secondaryTextColor: Color {
        AppConstants.Colors.dynamicSecondaryText(colorScheme)
    }
    
    private var cardBackgroundColor: Color {
        AppConstants.Colors.dynamicBackground(colorScheme)
    }
}

// MARK: - Extensions

private extension HiredAgentsView {
    var backgroundColor: Color {
        AppConstants.Colors.dynamicBackground(colorScheme)
    }
    
    var primaryTextColor: Color {
        AppConstants.Colors.dynamicPrimaryText(colorScheme)
    }
    
    var secondaryTextColor: Color {
        AppConstants.Colors.dynamicSecondaryText(colorScheme)
    }
    
    var cardBackgroundColor: Color {
        AppConstants.Colors.dynamicBackground(colorScheme)
    }
    
    var searchBackgroundColor: Color {
        colorScheme == .dark ? AppConstants.Colors.darkSurfaceElevated : AppConstants.Colors.surface
    }
    
    var headerBackgroundColor: Color {
        colorScheme == .dark ? AppConstants.Colors.darkSurfaceElevated.opacity(0.8) : AppConstants.Colors.surfaceStrong
    }
}

// MARK: - Sort Options

enum SortOption: String, CaseIterable {
    case innovation = "Innovation"
    case tokenUsage = "Token Usage"
    case lastActive = "Last Active"
    case alphabetical = "Alphabetical"
}

// MARK: - Preview

#Preview {
    HiredAgentsView()
}
