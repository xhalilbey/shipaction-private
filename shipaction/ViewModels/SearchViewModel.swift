//
//  SearchViewModel.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import Observation

// MARK: - Search ViewModel

/// ViewModel for the Search tab (category-first filtering experience)
@Observable
final class SearchViewModel {
    
    // MARK: - State
    
    /// All agents fetched from service
    private(set) var agents: [Agent] = []
    
    /// Selected category filter (nil means show all)
    var selectedCategory: AgentCategory? {
        didSet { filterAgents() }
    }
    
    /// Filtered agents to display
    private(set) var filteredAgents: [Agent] = []
    
    /// Loading and error state
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    /// Available categories with counts (computed from fetched agents)
    var availableCategories: [(category: AgentCategory, count: Int)] {
        let counts = Dictionary(grouping: agents, by: { $0.category }).mapValues { $0.count }
        return AgentCategory.allCases.compactMap { category in
            if let c = counts[category], c > 0 { return (category, c) }
            return nil
        }.sorted { $0.count > $1.count }
    }
    
    // MARK: - Dependencies
    private let agentService: AgentServiceProtocol
    
    // MARK: - Init
    init(agentService: AgentServiceProtocol = MockAgentService()) {
        self.agentService = agentService
    }
    
    // MARK: - Public API
    @MainActor
    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            agents = try await agentService.fetchAgents()
            filterAgents()
        } catch {
            errorMessage = "Failed to load data. Please try again."
        }
        isLoading = false
    }
    
    func toggleCategory(_ category: AgentCategory) {
        if selectedCategory == category { selectedCategory = nil } else { selectedCategory = category }
    }
    
    func clearFilters() {
        selectedCategory = nil
    }
    
    // MARK: - Private
    private func filterAgents() {
        let base = agents
        if let category = selectedCategory {
            filteredAgents = base.filter { $0.category == category }
        } else {
            filteredAgents = base
        }
        // Sort by rating then reviews for nicer presentation
        filteredAgents.sort { lhs, rhs in
            if lhs.rating != rhs.rating { return lhs.rating > rhs.rating }
            return lhs.reviewCount > rhs.reviewCount
        }
    }
}