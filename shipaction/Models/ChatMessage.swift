//
//  ChatMessage.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation

// MARK: - Chat Message Model

/// Model representing a chat message in AI conversation
struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp = Date()
}