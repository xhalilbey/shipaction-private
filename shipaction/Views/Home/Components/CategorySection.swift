//
//  CategorySection.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Category Section

/// Reusable section component for displaying agent categories
struct CategorySection: View {
    let title: String
    let subtitle: String
    let agents: [Agent]
    let onAgentStart: (Agent) -> Void
    let onAgentDetail: ((Agent) -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(AppConstants.Colors.dynamicSecondaryText(colorScheme))
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // Agents Grid
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(agents) { agent in
                        AgentCard(
                            agent: agent,
                            onStartTapped: { _ in
                                onAgentStart(agent)
                            },
                            onDetailTapped: onAgentDetail
                        )
                        .frame(width: 200, height: 240) // Fixed dimensions for consistent positioning
                        .clipped() // Ensure content doesn't overflow fixed bounds
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}