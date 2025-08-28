//
//  HiredAgent.swift
//  shipaction
//
//  Created by Assistant on 08.08.2025.
//

import Foundation
import SwiftUI

// MARK: - Hired Agent Model

/// Represents a hired AI agent with usage statistics and status
struct HiredAgent: Identifiable, Codable {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let category: String
    let hiredDate: Date
    let innovationScore: Double
    let tokenUsage: Int
    let lastActiveDate: Date
    let status: AgentStatus
    let notificationCount: Int
    let innovationTrend: Trend
    let avatarColorHex: String
    
    // MARK: - Computed Properties
    
    /// Agent initials for avatar
    var initials: String {
        let components = name.components(separatedBy: " ")
        if components.count >= 2 {
            let first = components[0].prefix(1)
            let last = components[1].prefix(1)
            return "\(first)\(last)".uppercased()
        } else {
            return String(name.prefix(2)).uppercased()
        }
    }
    
    /// Avatar color from hex
    var avatarColor: Color {
        Color(hex: avatarColorHex)
    }
    
    /// Formatted token usage
    var tokenUsageFormatted: String {
        if tokenUsage >= 1000000 {
            return String(format: "%.1fM", Double(tokenUsage) / 1000000)
        } else if tokenUsage >= 1000 {
            return String(format: "%.1fK", Double(tokenUsage) / 1000)
        } else {
            return "\(tokenUsage)"
        }
    }
    
    /// Token usage status color
    var tokenUsageColor: Color {
        switch tokenUsage {
        case 0..<1000:
            return .green
        case 1000..<10000:
            return .orange
        default:
            return .red
        }
    }
    
    /// Token usage status text
    var tokenUsageStatus: String {
        switch tokenUsage {
        case 0..<1000:
            return "Low"
        case 1000..<10000:
            return "Medium"
        default:
            return "High"
        }
    }
    
    /// Status color
    var statusColor: Color {
        switch status {
        case .active:
            return .green
        case .idle:
            return .orange
        case .offline:
            return .gray
        case .error:
            return .red
        }
    }
    
    /// Has notifications
    var hasNotifications: Bool {
        notificationCount > 0
    }
    
    /// Innovation trend text
    var innovationTrendText: String {
        switch innovationTrend {
        case .up:
            return "+0.2"
        case .down:
            return "-0.1"
        case .stable:
            return "0.0"
        }
    }
}

// MARK: - Agent Status

enum AgentStatus: String, Codable, CaseIterable {
    case active = "Active"
    case idle = "Idle"
    case offline = "Offline"
    case error = "Error"
}

// MARK: - Trend

enum Trend: String, Codable, CaseIterable {
    case up = "up"
    case down = "down"
    case stable = "stable"
}

// MARK: - Sample Data

extension HiredAgent {
    
    static let sampleHiredAgents: [HiredAgent] = [
        HiredAgent(
            id: "hired-1",
            name: "TaskMaster AI",
            category: "Productivity",
            hiredDate: Date().addingTimeInterval(-86400 * 15),
            innovationScore: 9.2,
            tokenUsage: 15420,
            lastActiveDate: Date().addingTimeInterval(-3600 * 2),
            status: .active,
            notificationCount: 3,
            innovationTrend: .up,
            avatarColorHex: "4F46E5"
        ),
        
        HiredAgent(
            id: "hired-2",
            name: "SocialMediaGenius",
            category: "Social Media",
            hiredDate: Date().addingTimeInterval(-86400 * 8),
            innovationScore: 9.7,
            tokenUsage: 28750,
            lastActiveDate: Date().addingTimeInterval(-3600),
            status: .active,
            notificationCount: 1,
            innovationTrend: .up,
            avatarColorHex: "EC4899"
        ),
        
        HiredAgent(
            id: "hired-3",
            name: "BizAnalyzer Pro",
            category: "Business",
            hiredDate: Date().addingTimeInterval(-86400 * 22),
            innovationScore: 8.9,
            tokenUsage: 12300,
            lastActiveDate: Date().addingTimeInterval(-3600 * 4),
            status: .idle,
            notificationCount: 0,
            innovationTrend: .stable,
            avatarColorHex: "059669"
        ),
        
        HiredAgent(
            id: "hired-4",
            name: "FinanceWizard",
            category: "Finance",
            hiredDate: Date().addingTimeInterval(-86400 * 30),
            innovationScore: 8.5,
            tokenUsage: 8950,
            lastActiveDate: Date().addingTimeInterval(-3600 * 6),
            status: .active,
            notificationCount: 2,
            innovationTrend: .down,
            avatarColorHex: "DC2626"
        ),
        
        HiredAgent(
            id: "hired-5",
            name: "StudyMentor AI",
            category: "Education",
            hiredDate: Date().addingTimeInterval(-86400 * 12),
            innovationScore: 9.4,
            tokenUsage: 22100,
            lastActiveDate: Date().addingTimeInterval(-3600 * 8),
            status: .offline,
            notificationCount: 0,
            innovationTrend: .up,
            avatarColorHex: "7C3AED"
        ),
        
        HiredAgent(
            id: "hired-6",
            name: "MarketingGuru",
            category: "Marketing",
            hiredDate: Date().addingTimeInterval(-86400 * 18),
            innovationScore: 8.7,
            tokenUsage: 16800,
            lastActiveDate: Date().addingTimeInterval(-3600 * 12),
            status: .active,
            notificationCount: 5,
            innovationTrend: .up,
            avatarColorHex: "F59E0B"
        ),
        
        HiredAgent(
            id: "hired-7",
            name: "TripPlanner AI",
            category: "Travel",
            hiredDate: Date().addingTimeInterval(-86400 * 5),
            innovationScore: 8.3,
            tokenUsage: 5420,
            lastActiveDate: Date().addingTimeInterval(-3600 * 24),
            status: .idle,
            notificationCount: 1,
            innovationTrend: .stable,
            avatarColorHex: "06B6D4"
        ),
        
        HiredAgent(
            id: "hired-8",
            name: "ShopAssistant",
            category: "E-commerce",
            hiredDate: Date().addingTimeInterval(-86400 * 25),
            innovationScore: 9.1,
            tokenUsage: 19500,
            lastActiveDate: Date().addingTimeInterval(-3600),
            status: .active,
            notificationCount: 0,
            innovationTrend: .up,
            avatarColorHex: "84CC16"
        ),
        
        HiredAgent(
            id: "hired-9",
            name: "ContentCreator Pro",
            category: "Creative",
            hiredDate: Date().addingTimeInterval(-86400 * 10),
            innovationScore: 9.6,
            tokenUsage: 31200,
            lastActiveDate: Date().addingTimeInterval(-3600 * 3),
            status: .error,
            notificationCount: 8,
            innovationTrend: .down,
            avatarColorHex: "EF4444"
        ),
        
        HiredAgent(
            id: "hired-10",
            name: "DataAnalyst AI",
            category: "Analytics",
            hiredDate: Date().addingTimeInterval(-86400 * 35),
            innovationScore: 8.8,
            tokenUsage: 14750,
            lastActiveDate: Date().addingTimeInterval(-3600 * 5),
            status: .active,
            notificationCount: 2,
            innovationTrend: .stable,
            avatarColorHex: "8B5CF6"
        )
    ]
}
