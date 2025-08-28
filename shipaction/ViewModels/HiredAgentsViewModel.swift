//
//  HiredAgentsViewModel.swift
//  shipaction
//
//  Created by Assistant on 08.08.2025.
//

import Foundation
import SwiftUI

// MARK: - Hired Agents ViewModel

/// ViewModel for managing hired agents data and operations
@MainActor
final class HiredAgentsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var hiredAgents: [HiredAgent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Statistics
    
    @Published var totalTokensUsed: Int = 0
    @Published var averageInnovationScore: Double = 0.0
    @Published var activeAgentsCount: Int = 0
    @Published var totalNotifications: Int = 0
    
    // MARK: - Dependencies
    
    private let networkManager: NetworkManager
    private let loggingService: LoggingService
    
    // MARK: - Initialization
    
    init(
        networkManager: NetworkManager = NetworkManager.shared,
        loggingService: LoggingService = LoggingService.shared
    ) {
        self.networkManager = networkManager
        self.loggingService = loggingService
    }
    
    // MARK: - Public Methods
    
    /// Loads hired agents from the server
    func loadHiredAgents() {
        Task {
            await performLoadHiredAgents()
        }
    }
    
    /// Refreshes hired agents data
    func refreshHiredAgents() {
        Task {
            await performLoadHiredAgents(forceRefresh: true)
        }
    }
    
    /// Fires (removes) a hired agent
    func fireAgent(_ agent: HiredAgent) {
        Task {
            await performFireAgent(agent)
        }
    }
    
    /// Sends a message to an agent
    func sendMessageToAgent(_ agent: HiredAgent, message: String) {
        Task {
            await performSendMessage(to: agent, message: message)
        }
    }
    
    /// Marks notifications as read for an agent
    func markNotificationsAsRead(for agent: HiredAgent) {
        Task {
            await performMarkNotificationsAsRead(for: agent)
        }
    }
    
    // MARK: - Private Methods
    
    private func performLoadHiredAgents(forceRefresh: Bool = false) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // For now, use sample data. In production, this would be a network call
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
            
            hiredAgents = HiredAgent.sampleHiredAgents
            calculateStatistics()
            
            loggingService.logInfo("Successfully loaded \(hiredAgents.count) hired agents")
            
        } catch {
            errorMessage = "Failed to load hired agents"
            loggingService.logError(error, context: "Loading hired agents")
        }
        
        isLoading = false
    }
    
    private func performFireAgent(_ agent: HiredAgent) async {
        do {
            // Simulate network call
            try await Task.sleep(nanoseconds: 500_000_000)
            
            // Remove agent from local list
            hiredAgents.removeAll { $0.id == agent.id }
            calculateStatistics()
            
            loggingService.logInfo("Successfully fired agent: \(agent.name)")
            
        } catch {
            errorMessage = "Failed to fire agent"
            loggingService.logError(error, context: "Firing agent")
        }
    }
    
    private func performSendMessage(to agent: HiredAgent, message: String) async {
        do {
            // Simulate network call
            try await Task.sleep(nanoseconds: 300_000_000)
            
            loggingService.logInfo("Message sent to agent: \(agent.name)")
            
        } catch {
            errorMessage = "Failed to send message"
            loggingService.logError(error, context: "Sending message to agent")
        }
    }
    
    private func performMarkNotificationsAsRead(for agent: HiredAgent) async {
        do {
            // Simulate network call
            try await Task.sleep(nanoseconds: 200_000_000)
            
            // Update agent in local list
            if let index = hiredAgents.firstIndex(where: { $0.id == agent.id }) {
                var updatedAgent = hiredAgents[index]
                // Create a new agent with notificationCount = 0
                let newAgent = HiredAgent(
                    id: updatedAgent.id,
                    name: updatedAgent.name,
                    category: updatedAgent.category,
                    hiredDate: updatedAgent.hiredDate,
                    innovationScore: updatedAgent.innovationScore,
                    tokenUsage: updatedAgent.tokenUsage,
                    lastActiveDate: updatedAgent.lastActiveDate,
                    status: updatedAgent.status,
                    notificationCount: 0,
                    innovationTrend: updatedAgent.innovationTrend,
                    avatarColorHex: updatedAgent.avatarColorHex
                )
                hiredAgents[index] = newAgent
            }
            
            calculateStatistics()
            loggingService.logInfo("Notifications marked as read for agent: \(agent.name)")
            
        } catch {
            errorMessage = "Failed to mark notifications as read"
            loggingService.logError(error, context: "Marking notifications as read")
        }
    }
    
    private func calculateStatistics() {
        totalTokensUsed = hiredAgents.reduce(0) { $0 + $1.tokenUsage }
        
        if !hiredAgents.isEmpty {
            averageInnovationScore = hiredAgents.reduce(0.0) { $0 + $1.innovationScore } / Double(hiredAgents.count)
        } else {
            averageInnovationScore = 0.0
        }
        
        activeAgentsCount = hiredAgents.filter { $0.status == .active }.count
        totalNotifications = hiredAgents.reduce(0) { $0 + $1.notificationCount }
    }
}

// MARK: - Statistics Computed Properties

extension HiredAgentsViewModel {
    
    /// Formatted total tokens used
    var totalTokensFormatted: String {
        if totalTokensUsed >= 1000000 {
            return String(format: "%.1fM", Double(totalTokensUsed) / 1000000)
        } else if totalTokensUsed >= 1000 {
            return String(format: "%.1fK", Double(totalTokensUsed) / 1000)
        } else {
            return "\(totalTokensUsed)"
        }
    }
    
    /// Formatted average innovation score
    var averageInnovationScoreFormatted: String {
        return String(format: "%.1f", averageInnovationScore)
    }
    
    /// Innovation performance status
    var innovationPerformanceStatus: String {
        switch averageInnovationScore {
        case 9.0...:
            return "Excellent"
        case 8.0..<9.0:
            return "Good"
        case 7.0..<8.0:
            return "Average"
        default:
            return "Needs Improvement"
        }
    }
    
    /// Innovation performance color
    var innovationPerformanceColor: Color {
        switch averageInnovationScore {
        case 9.0...:
            return .green
        case 8.0..<9.0:
            return .blue
        case 7.0..<8.0:
            return .orange
        default:
            return .red
        }
    }
}
