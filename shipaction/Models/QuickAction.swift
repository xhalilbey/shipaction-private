//
//  QuickAction.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import SwiftUI

// MARK: - Quick Action Model

/// Model representing a quick action button in the home dashboard
struct QuickAction: Identifiable {
    let id: String
    let title: String
    let icon: String
    let color: Color
}