//
//  SearchViewModel.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import Observation
import Combine

// MARK: - Search ViewModel

/// ViewModel for the Search tab with debounced search functionality
@Observable
final class SearchViewModel {
    
    // MARK: - State
    
    /// All agents fetched from service
    private(set) var agents: [Agent] = []
    
    /// Search query with debouncing
    var searchQuery: String = "" {
        didSet {
            searchSubject.send(searchQuery)
        }
    }
    
    /// Selected category filter (nil means show all)
    var selectedCategory: AgentCategory? {
        didSet { filterAgents() }
    }
    
    /// Filtered agents to display
    private(set) var filteredAgents: [Agent] = []
    
    /// Loading and error state
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private var hasLoaded = false
    
    /// Available categories with counts (computed from fetched agents)
    var availableCategories: [(category: AgentCategory, count: Int)] {
        let counts = Dictionary(grouping: agents, by: { $0.category })
            .mapValues { $0.count }
        return AgentCategory.allCases.compactMap { category in
            if let c = counts[category], c > 0 { 
                return (category, c) 
            }
            return nil
        }.sorted { $0.count > $1.count }
    }
    
    var isEmpty: Bool {
        !isLoading && filteredAgents.isEmpty
    }
    
    // MARK: - Dependencies & Combine
    
    private let agentService: AgentServiceProtocol
    private let searchSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(agentService: AgentServiceProtocol = MockAgentService()) {
        self.agentService = agentService
        setupSearchDebouncing()
    }
    
    // MARK: - Setup
    
    private func setupSearchDebouncing() {
        searchSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.filterAgents()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public API
    
    @MainActor
    func load() async {
        guard !isLoading && !hasLoaded else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            agents = try await agentService.fetchAgents()
            filterAgents()
            hasLoaded = true
        } catch {
            errorMessage = "Failed to load data. Please try again."
            print("SearchViewModel.load error: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func refresh() async {
        errorMessage = nil
        hasLoaded = false
        await load()
    }
    
    func toggleCategory(_ category: AgentCategory) {
        if selectedCategory == category { 
            selectedCategory = nil 
        } else { 
            selectedCategory = category 
        }
    }
    
    func clearFilters() {
        searchQuery = ""
        selectedCategory = nil
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private
    
    private func filterAgents() {
        var result = agents
        
        // Apply search filter
        if !searchQuery.isEmpty {
            let query = searchQuery.lowercased()
            result = result.filter { agent in
                agent.name.lowercased().contains(query) ||
                agent.description.lowercased().contains(query) ||
                agent.tags.contains { $0.lowercased().contains(query) }
            }
        }
        
        // Apply category filter
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        // Sort by rating then reviews
        result.sort { lhs, rhs in
            if lhs.rating != rhs.rating { 
                return lhs.rating > rhs.rating 
            }
            return lhs.reviewCount > rhs.reviewCount
        }
        
        filteredAgents = result
    }
}