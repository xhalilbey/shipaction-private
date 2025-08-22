//
//  Agent.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import Foundation

// MARK: - Agent Model

/// Represents an AI Agent in the marketplace
struct Agent: Identifiable, Codable, Hashable {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let description: String
    let category: AgentCategory
    let logoURL: String?
    let rating: Double
    let reviewCount: Int
    let price: AgentPrice
    let tags: [String]
    let isRecommended: Bool
    let isBestPerforming: Bool
    let createdAt: Date
    let updatedAt: Date
    
    // MARK: - Computed Properties
    
    /// Formatted rating string
    var formattedRating: String {
        return String(format: "%.1f", rating)
    }
    
    /// Review count text
    var reviewText: String {
        if reviewCount == 0 {
            return "No reviews"
        } else if reviewCount == 1 {
            return "1 review"
        } else {
            return "\(reviewCount) reviews"
        }
    }
    
    /// Price display text
    var priceText: String {
        switch price {
        case .free:
            return "Free"
        case .oneTime(let amount):
            return "$\(amount)"
        case .subscription(let amount, let period):
            return "$\(amount)/\(period.rawValue)"
        }
    }
}

// MARK: - Agent Category

enum AgentCategory: String, CaseIterable, Codable {
    case productivity = "productivity"
    case creative = "social_media"
    case business = "business"
    case education = "education"
    case healthcare = "healthcare"
    case finance = "finance"
    case marketing = "marketing"
    case education_dev = "education_dev"
    case customer_service = "customer_service"
    case analytics = "analytics"
    case travel = "travel"
    case ecommerce = "ecommerce"
    
    var displayName: String {
        switch self {
        case .productivity:
            return "Productivity"
        case .creative:
            return "Social Media"
        case .business:
            return "Health & Fitness"
        case .education:
            return "Education"
        case .healthcare:
            return "Healthcare"
        case .finance:
            return "Finance"
        case .marketing:
            return "Marketing"
        case .education_dev:
            return "Education"
        case .customer_service:
            return "Customer Service"
        case .analytics:
            return "Analytics"
        case .travel:
            return "Travel"
        case .ecommerce:
            return "E-commerce"
        }
    }
    
    var iconName: String {
        switch self {
        case .productivity:
            return "checkmark.circle.fill"
        case .creative:
            return "message.fill"
        case .business:
            return "heart.fill"
        case .education:
            return "graduationcap.fill"
        case .healthcare:
            return "cross.circle.fill"
        case .finance:
            return "dollarsign.circle.fill"
        case .marketing:
            return "megaphone.fill"
        case .education_dev:
            return "graduationcap.fill"
        case .customer_service:
            return "person.2.fill"
        case .analytics:
            return "chart.bar.fill"
        case .travel:
            return "airplane"
        case .ecommerce:
            return "cart.fill"
        }
    }
}

// MARK: - Agent Price

enum AgentPrice: Codable, Hashable {
    case free
    case oneTime(Int)
    case subscription(Int, SubscriptionPeriod)
    
    enum SubscriptionPeriod: String, Codable {
        case monthly = "month"
        case yearly = "year"
    }
}

// MARK: - Sample Data

extension Agent {
    
    static let sampleAgents: [Agent] = [
        // Productivity Agents
        Agent(
            id: "agent-1",
            name: "TaskMaster AI",
            description: "Advanced task management and productivity optimization assistant",
            category: .productivity,
            logoURL: nil,
            rating: 4.8,
            reviewCount: 156,
            price: .subscription(9, .monthly),
            tags: ["Task Management", "Productivity", "Organization"],
            isRecommended: true,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 30),
            updatedAt: Date().addingTimeInterval(-86400 * 2)
        ),
        
        // Social Media Agents
        Agent(
            id: "agent-2",
            name: "SocialMediaGenius",
            description: "AI-powered social media content generation and scheduling",
            category: .creative,
            logoURL: nil,
            rating: 4.9,
            reviewCount: 203,
            price: .subscription(15, .monthly),
            tags: ["Content Creation", "Design", "Marketing"],
            isRecommended: true,
            isBestPerforming: true,
            createdAt: Date().addingTimeInterval(-86400 * 45),
            updatedAt: Date().addingTimeInterval(-86400 * 1)
        ),
        
        // Business Agents
        Agent(
            id: "agent-3",
            name: "BizAnalyzer Pro",
            description: "Comprehensive business analysis and strategic planning assistant",
            category: .business,
            logoURL: nil,
            rating: 4.7,
            reviewCount: 89,
            price: .subscription(25, .monthly),
            tags: ["Business Analysis", "Strategy", "Planning"],
            isRecommended: false,
            isBestPerforming: true,
            createdAt: Date().addingTimeInterval(-86400 * 20),
            updatedAt: Date().addingTimeInterval(-86400 * 3)
        ),
        
        // Finance Agents
        Agent(
            id: "agent-4",
            name: "FinanceWizard",
            description: "Personal finance management and investment advisory AI",
            category: .finance,
            logoURL: nil,
            rating: 4.6,
            reviewCount: 127,
            price: .free,
            tags: ["Finance", "Investment", "Budgeting"],
            isRecommended: true,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 60),
            updatedAt: Date().addingTimeInterval(-86400 * 5)
        ),
        
        // Education Agents
        Agent(
            id: "agent-5",
            name: "StudyMentor AI",
            description: "Personalized learning assistant and study planner",
            category: .education_dev,
            logoURL: nil,
            rating: 4.9,
            reviewCount: 312,
            price: .subscription(20, .monthly),
            tags: ["Learning", "Study", "Planner"],
            isRecommended: false,
            isBestPerforming: true,
            createdAt: Date().addingTimeInterval(-86400 * 35),
            updatedAt: Date().addingTimeInterval(-86400 * 1)
        ),
        
        // Marketing Agents
        Agent(
            id: "agent-6",
            name: "MarketingGuru",
            description: "Digital marketing optimization and campaign management AI",
            category: .marketing,
            logoURL: nil,
            rating: 4.5,
            reviewCount: 78,
            price: .oneTime(49),
            tags: ["Marketing", "Campaigns", "SEO"],
            isRecommended: true,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 15),
            updatedAt: Date().addingTimeInterval(-86400 * 4)
        ),
        
        // Travel Agents
        Agent(
            id: "agent-7",
            name: "TripPlanner AI",
            description: "Smart itinerary planning, best deal search, and travel assistant",
            category: .travel,
            logoURL: nil,
            rating: 4.6,
            reviewCount: 142,
            price: .subscription(12, .monthly),
            tags: ["Itinerary", "Flights", "Hotels"],
            isRecommended: true,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 18),
            updatedAt: Date().addingTimeInterval(-86400 * 2)
        ),
        
        // E-commerce Agents
        Agent(
            id: "agent-8",
            name: "ShopAssistant",
            description: "Product recommendations, pricing insights, and store analytics",
            category: .ecommerce,
            logoURL: nil,
            rating: 4.7,
            reviewCount: 96,
            price: .subscription(19, .monthly),
            tags: ["Recommendations", "Pricing", "Analytics"],
            isRecommended: false,
            isBestPerforming: true,
            createdAt: Date().addingTimeInterval(-86400 * 22),
            updatedAt: Date().addingTimeInterval(-86400 * 1)
        ),
        
        // More Productivity Agents
        Agent(
            id: "agent-9",
            name: "FocusFlow",
            description: "Time tracking and focus enhancement with AI-powered insights",
            category: .productivity,
            logoURL: nil,
            rating: 4.5,
            reviewCount: 89,
            price: .subscription(7, .monthly),
            tags: ["Time Tracking", "Focus", "Insights"],
            isRecommended: true,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 12),
            updatedAt: Date().addingTimeInterval(-86400 * 1)
        ),
        
        Agent(
            id: "agent-10",
            name: "MeetingMaster",
            description: "Smart meeting scheduling and note-taking assistant",
            category: .productivity,
            logoURL: nil,
            rating: 4.8,
            reviewCount: 134,
            price: .subscription(12, .monthly),
            tags: ["Meetings", "Scheduling", "Notes"],
            isRecommended: false,
            isBestPerforming: true,
            createdAt: Date().addingTimeInterval(-86400 * 25),
            updatedAt: Date().addingTimeInterval(-86400 * 2)
        ),
        
        // More Social Media Agents
        Agent(
            id: "agent-11",
            name: "ContentCreator Pro",
            description: "AI-powered video and image content creation for social platforms",
            category: .creative,
            logoURL: nil,
            rating: 4.6,
            reviewCount: 178,
            price: .subscription(18, .monthly),
            tags: ["Video", "Images", "Creation"],
            isRecommended: true,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 18),
            updatedAt: Date().addingTimeInterval(-86400 * 1)
        ),
        
        Agent(
            id: "agent-12",
            name: "HashtagOptimizer",
            description: "Smart hashtag research and social media optimization",
            category: .creative,
            logoURL: nil,
            rating: 4.4,
            reviewCount: 92,
            price: .free,
            tags: ["Hashtags", "Optimization", "Research"],
            isRecommended: false,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 8),
            updatedAt: Date().addingTimeInterval(-86400 * 1)
        ),
        
        // More Finance Agents
        Agent(
            id: "agent-13",
            name: "CryptoAnalyzer",
            description: "Cryptocurrency market analysis and portfolio tracking",
            category: .finance,
            logoURL: nil,
            rating: 4.3,
            reviewCount: 67,
            price: .subscription(15, .monthly),
            tags: ["Crypto", "Portfolio", "Analysis"],
            isRecommended: false,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 14),
            updatedAt: Date().addingTimeInterval(-86400 * 3)
        ),
        
        Agent(
            id: "agent-14",
            name: "TaxHelper AI",
            description: "Automated tax preparation and optimization assistant",
            category: .finance,
            logoURL: nil,
            rating: 4.7,
            reviewCount: 156,
            price: .oneTime(29),
            tags: ["Tax", "Preparation", "Optimization"],
            isRecommended: true,
            isBestPerforming: true,
            createdAt: Date().addingTimeInterval(-86400 * 40),
            updatedAt: Date().addingTimeInterval(-86400 * 2)
        ),
        
        // More Marketing Agents
        Agent(
            id: "agent-15",
            name: "EmailCampaign Pro",
            description: "Advanced email marketing automation and analytics",
            category: .marketing,
            logoURL: nil,
            rating: 4.6,
            reviewCount: 123,
            price: .subscription(22, .monthly),
            tags: ["Email", "Automation", "Analytics"],
            isRecommended: true,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 28),
            updatedAt: Date().addingTimeInterval(-86400 * 1)
        ),
        
        Agent(
            id: "agent-16",
            name: "AdOptimizer",
            description: "AI-driven ad campaign optimization across all platforms",
            category: .marketing,
            logoURL: nil,
            rating: 4.8,
            reviewCount: 87,
            price: .subscription(35, .monthly),
            tags: ["Ads", "Optimization", "Campaigns"],
            isRecommended: false,
            isBestPerforming: true,
            createdAt: Date().addingTimeInterval(-86400 * 16),
            updatedAt: Date().addingTimeInterval(-86400 * 1)
        ),
        
        // More Education Agents
        Agent(
            id: "agent-17",
            name: "LanguageTutor AI",
            description: "Personalized language learning with conversation practice",
            category: .education_dev,
            logoURL: nil,
            rating: 4.9,
            reviewCount: 245,
            price: .subscription(14, .monthly),
            tags: ["Language", "Learning", "Conversation"],
            isRecommended: true,
            isBestPerforming: true,
            createdAt: Date().addingTimeInterval(-86400 * 33),
            updatedAt: Date().addingTimeInterval(-86400 * 1)
        ),
        
        Agent(
            id: "agent-18",
            name: "SkillBuilder",
            description: "Professional skill development and career planning assistant",
            category: .education_dev,
            logoURL: nil,
            rating: 4.5,
            reviewCount: 108,
            price: .subscription(16, .monthly),
            tags: ["Skills", "Career", "Development"],
            isRecommended: false,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 21),
            updatedAt: Date().addingTimeInterval(-86400 * 2)
        ),
        
        // More Travel Agents
        Agent(
            id: "agent-19",
            name: "LocalGuide AI",
            description: "Discover hidden gems and local experiences in any city",
            category: .travel,
            logoURL: nil,
            rating: 4.4,
            reviewCount: 76,
            price: .free,
            tags: ["Local", "Experiences", "Discovery"],
            isRecommended: true,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 11),
            updatedAt: Date().addingTimeInterval(-86400 * 1)
        ),
        
        Agent(
            id: "agent-20",
            name: "BudgetTravel Pro",
            description: "Find the best deals and budget-friendly travel options",
            category: .travel,
            logoURL: nil,
            rating: 4.6,
            reviewCount: 134,
            price: .subscription(8, .monthly),
            tags: ["Budget", "Deals", "Savings"],
            isRecommended: false,
            isBestPerforming: false,
            createdAt: Date().addingTimeInterval(-86400 * 19),
            updatedAt: Date().addingTimeInterval(-86400 * 2)
        )
    ]
}