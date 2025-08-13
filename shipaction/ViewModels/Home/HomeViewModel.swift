//
//  HomeViewModel.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import Foundation
import Observation

// MARK: - Home View Model

/// ViewModel for the home marketplace view following MVVM architecture
@Observable
final class HomeViewModel {
    
    // MARK: - Properties
    
    /// All available agents
    private(set) var agents: [Agent] = []
    
    /// Loading state for data fetching
    private(set) var isLoading: Bool = false

    /// Prevent duplicate initial loads
    private(set) var hasLoaded: Bool = false
    
    /// Error message for display
    private(set) var errorMessage: String?
    
    /// Search query for filtering agents
    var searchQuery: String = "" {
        didSet {
            filterAgents()
        }
    }
    
    /// Selected category filter
    var selectedCategory: AgentCategory? {
        didSet {
            filterAgents()
        }
    }
    
    /// Filtered agents based on search and category
    private(set) var filteredAgents: [Agent] = []
    
    // MARK: - Dependencies
    
    private let agentService: AgentServiceProtocol
    
    // MARK: - Initialization
    
    init(agentService: AgentServiceProtocol = MockAgentService()) {
        self.agentService = agentService
    }
    
    // MARK: - Computed Properties
    
    /// Agents organized by categories
    var categorizedAgents: [Agent] {
        return filteredAgents.filter { agent in
            AgentCategory.allCases.contains(agent.category)
        }
    }
    
    /// Best performing agents
    var bestPerformingAgents: [Agent] {
        let filtered = applyFilters(to: agents)
        return filtered
            .filter { $0.isBestPerforming }
            .sorted { $0.rating > $1.rating }
            .prefix(6)
            .map { $0 }
    }
    
    /// Recommended agents
    var recommendedAgents: [Agent] {
        let filtered = applyFilters(to: agents)
        return filtered
            .filter { $0.isRecommended }
            .sorted { $0.rating > $1.rating }
            .prefix(6)
            .map { $0 }
    }
    
    /// Most used agents (based on review count as proxy for usage)
    var mostUsedAgents: [Agent] {
        let filtered = applyFilters(to: agents)
        return filtered
            .sorted { $0.reviewCount > $1.reviewCount }
            .prefix(6)
            .map { $0 }
    }
    
    /// Available categories with agent counts
    var availableCategories: [(category: AgentCategory, count: Int)] {
        let categoryCounts = Dictionary(grouping: agents, by: { $0.category })
            .mapValues { $0.count }
        
        return AgentCategory.allCases.compactMap { category in
            if let count = categoryCounts[category], count > 0 {
                return (category: category, count: count)
            }
            return nil
        }.sorted { $0.count > $1.count }
    }
    
    // MARK: - Public Methods
    
    /// Loads agents from the service
    @MainActor
    func loadAgents() async {
        guard !isLoading && !hasLoaded else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            agents = try await agentService.fetchAgents()
            filterAgents()
            hasLoaded = true
        } catch {
            errorMessage = "Failed to load agents. Please try again."
            print("HomeViewModel.loadAgents error: \(error)")
        }
        
        isLoading = false
    }
    
    /// Refreshes agent data without showing loading state
    @MainActor
    func refreshAgents() async {
        do {
            agents = try await agentService.fetchAgents()
            filterAgents()
        } catch {
            errorMessage = "Failed to refresh agents. Please try again."
            print("HomeViewModel.refreshAgents error: \(error)")
        }
    }
    
    /// Starts an agent (placeholder for future implementation)
    func startAgent(_ agent: Agent) {
        // TODO: Implement agent start functionality
        print("Starting agent: \(agent.name)")
    }
    
    /// Clears all filters
    func clearFilters() {
        searchQuery = ""
        selectedCategory = nil
    }
    
    /// Clears error message
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    
    /// Filters agents based on search query and selected category
    private func filterAgents() {
        filteredAgents = applyFilters(to: agents).sorted { lhs, rhs in
            // Sort by rating first, then by review count
            if lhs.rating != rhs.rating {
                return lhs.rating > rhs.rating
            }
            return lhs.reviewCount > rhs.reviewCount
        }
    }
    
    /// Applies only search filter to a given array of agents (no category filtering)
    private func applySearchFilter(to agents: [Agent]) -> [Agent] {
        if searchQuery.isEmpty {
            return agents
        }
        
        return agents.filter { agent in
            agent.name.localizedCaseInsensitiveContains(searchQuery) ||
            agent.description.localizedCaseInsensitiveContains(searchQuery) ||
            agent.tags.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    /// Applies search and category filters to a given array of agents
    private func applyFilters(to agents: [Agent]) -> [Agent] {
        var filtered = agents
        
        // Apply search filter
        if !searchQuery.isEmpty {
            filtered = filtered.filter { agent in
                agent.name.localizedCaseInsensitiveContains(searchQuery) ||
                agent.description.localizedCaseInsensitiveContains(searchQuery) ||
                agent.tags.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
            }
        }
        
        // Apply category filter
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        return filtered
    }
}

// MARK: - Agent Service Protocol

/// Protocol for agent data management
protocol AgentServiceProtocol {
    func fetchAgents() async throws -> [Agent]
    func fetchAgent(by id: String) async throws -> Agent?
}

// MARK: - Mock Agent Service

/// Mock implementation for development and testing
final class MockAgentService: AgentServiceProtocol {
    
    func fetchAgents() async throws -> [Agent] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return Agent.sampleAgents
    }
    
    func fetchAgent(by id: String) async throws -> Agent? {
        try await Task.sleep(nanoseconds: 500_000_000)
        return Agent.sampleAgents.first { $0.id == id }
    }
}