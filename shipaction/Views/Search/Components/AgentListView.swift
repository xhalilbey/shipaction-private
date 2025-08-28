//
//  AgentListView.swift
//  shipaction
//
//  Created by Assistant on 08.08.2025.
//

import SwiftUI

// MARK: - Agent List View

/// View for displaying a list of agents in a category
struct AgentListView: View {
    let category: AgentCategory
    let agents: [Agent]
    var namespace: Namespace.ID?
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Category Filter State
    @State private var selectedCategory: AgentCategory?
    @State private var allAgents: [Agent] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Category Filter Chips
            if !availableCategories.isEmpty {
                categoryFilterSection
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                    .background(backgroundColor)
            }
            
            // Agent Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
                    ForEach(filteredAgents) { agent in
                        AgentCard(
                            agent: agent,
                            onStartTapped: handleAgentStart,
                            onDetailTapped: handleAgentDetail
                        )
                        .frame(height: 240) // Fixed height for consistent grid layout
                        .clipped() // Ensure content doesn't overflow fixed bounds
                    }
                }
                .padding(16)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                titleView
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(backgroundColor)
        .onAppear {
            setupInitialData()
        }
    }
    
    // MARK: - Actions
    
    private func handleAgentStart(_ agent: Agent) {
        // Placeholder action for search context
        print("Start tapped: \(agent.name)")
    }
    
    private func handleAgentDetail(_ agent: Agent) {
        // TODO: Navigate to agent detail in search context
        print("Detail tapped: \(agent.name)")
    }
    
    private func navigationBack() -> Bool { 
        dismiss()
        return true 
    }
    
    // MARK: - Data Management
    
    private func setupInitialData() {
        // Initialize with all sample agents and set the initial category
        allAgents = Agent.sampleAgents
        selectedCategory = category
    }
    
    // MARK: - Computed Properties
    
    private var availableCategories: [(category: AgentCategory, count: Int)] {
        let counts = Dictionary(grouping: allAgents, by: { $0.category })
            .mapValues { $0.count }
        return AgentCategory.allCases.compactMap { category in
            if let count = counts[category], count > 0 {
                return (category, count)
            }
            return nil
        }.sorted { $0.count > $1.count }
    }
    
    private var filteredAgents: [Agent] {
        if let selectedCategory = selectedCategory {
            return allAgents.filter { $0.category == selectedCategory }
        } else {
            return allAgents
        }
    }
    
    // MARK: - Category Filter Section
    
    private var categoryFilterSection: some View {
        CategoryFilterChips(
            categories: availableCategories,
            selectedCategory: $selectedCategory
        )
    }
    
    // MARK: - Subviews
    
    private var backButton: some View {
        Button(action: { _ = navigationBack() }) {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
                Text("Back")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
            }
        }
    }
    
    @ViewBuilder
    private var titleView: some View {
        if let ns = namespace {
            HStack(spacing: 8) {
                Image(systemName: category.iconName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
                    .matchedGeometryEffect(id: "icon-\(category.rawValue)", in: ns, isSource: false)
                Text(category.displayName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
            }
        } else {
            Text(category.displayName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
        }
    }
    
    // MARK: - Colors
    
    private var backgroundColor: Color { 
        AppConstants.Colors.dynamicBackground(colorScheme)
    }
}
