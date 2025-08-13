//
//  NetworkManager.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import Network
import Observation

// MARK: - Network Manager Protocol

/// Protocol defining network monitoring capabilities for dependency injection
protocol NetworkMonitoring {
    var isConnected: Bool { get }
    func hasInternetConnection() -> Bool
    func testInternetAccess() async -> Bool
}

// MARK: - Network Manager

/// Monitors network connectivity and provides real-time status updates
@Observable
final class NetworkManager: NetworkMonitoring {
    
    // MARK: - Singleton
    
    static let shared = NetworkManager()
    
    // MARK: - Properties
    
    /// Current network connection status
    private(set) var isConnected = true
    
    /// Network path monitor for real-time connectivity tracking
    private let monitor = NWPathMonitor()
    
    /// Queue for network monitoring operations
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    // MARK: - Initialization
    
    private init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    // MARK: - Public Methods
    
    /// Checks if device has active internet connection
    /// - Returns: Boolean indicating connectivity status
    func hasInternetConnection() -> Bool {
        return isConnected
    }
    
    /// Performs a simple network test to verify actual internet access
    /// - Returns: Boolean indicating if internet is actually accessible
    func testInternetAccess() async -> Bool {
        guard isConnected else { return false }
        
        do {
            let url = URL(string: "https://www.google.com")!
            let (_, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            return false
        } catch {
            print("Internet access test failed: \(error)")
            return false
        }
    }
    
    // MARK: - Private Methods
    
    /// Starts network path monitoring
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let wasConnected = self?.isConnected ?? false
                self?.isConnected = path.status == .satisfied
                
                // Log connection changes
                if wasConnected != self?.isConnected {
                    if self?.isConnected == true {
                        print("Network connection restored")
                    } else {
                        print("Network connection lost")
                    }
                }
            }
        }
        
        monitor.start(queue: queue)
        print("Network monitoring started")
    }
    
    /// Stops network path monitoring
    private func stopMonitoring() {
        monitor.cancel()
        print("Network monitoring stopped")
    }
}