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
    
    var body: some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // Agents Grid
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(agents) { agent in
                        AgentCard(agent: agent) { _ in
                            onAgentStart(agent)
                        }
                        .frame(width: 200) // Increased width to properly display all content including star ratings
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}