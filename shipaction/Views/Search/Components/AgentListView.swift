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
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(agents) { agent in
                    AgentCard(
                        agent: agent,
                        onStartTapped: handleAgentStart,
                        onDetailTapped: handleAgentDetail
                    )
                }
            }
            .padding(16)
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
