//
//  AIChatViewModel.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import Observation

// MARK: - AI Chat ViewModel

/// ViewModel for AI Chat tab
@Observable
final class AIChatViewModel {
    
    // MARK: - State
    
    var messages: [ChatMessage] = []
    var currentMessage = ""
    var isProcessing = false
    
    // MARK: - Chat Actions
    
    @MainActor
    func sendMessage() async {
        guard !currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let userMessage = ChatMessage(content: currentMessage, isUser: true)
        messages.append(userMessage)
        
        let messageToProcess = currentMessage
        currentMessage = ""
        isProcessing = true
        
        // Simulate AI response
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let aiResponse = ChatMessage(content: "AI yanıtı: \(messageToProcess)", isUser: false)
        messages.append(aiResponse)
        
        isProcessing = false
    }
}