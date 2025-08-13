//
//  LibraryTabView.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Library Tab View

/// Saved items library tab view - Coming Soon
struct LibraryTabView: View {
    
    // MARK: - Properties
    
    @Bindable var viewModel: LibraryViewModel
    private var colorScheme: ColorScheme { .light }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Çok yakında")
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
}

// MARK: - Saved Item Card

struct SavedItemCard: View {
    let item: SavedItem
    let onTap: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Item Icon
                Image(systemName: iconForItemType(item.type))
                    .font(.title2)
                    .foregroundStyle(AppConstants.Colors.primary)
                    .frame(width: 44, height: 44)
            .background(primaryTokenBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Item Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text(item.subtitle ?? "Saved item")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    Text(formatDate(item.savedAt))
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                
                Spacer()
                
                // More actions
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(16)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func iconForItemType(_ type: String) -> String {
        switch type.lowercased() {
        case "agent":
            return "sparkles"
        case "conversation":
            return "bubble.left.and.bubble.right"
        case "document":
            return "doc.text"
        default:
            return "bookmark"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    // MARK: - Tokens
    private var cardBackground: Color {
        colorScheme == .dark ? AppConstants.Colors.darkTokenBackground : Color(.secondarySystemBackground)
    }

    private var primaryTokenBackground: Color {
        colorScheme == .dark ? AppConstants.Colors.primary.opacity(0.16) : AppConstants.Colors.primary.opacity(0.1)
    }
}

// MARK: - Tokens
private extension LibraryTabView {
    var backgroundColor: Color { AppConstants.Colors.background }
}