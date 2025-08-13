//
//  TextFieldType.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI
import UIKit

// MARK: - Text Field Type Enum

/// Defines input behavior and validation rules for different text field types.
/// 
/// Each type configures appropriate keyboard settings, content types,
/// and autocapitalization behavior for optimal user experience.
enum TextFieldType {
    /// Email address input with email keyboard and validation
    case email
    /// Password input with secure text entry
    case password
    /// Generic text input with default settings
    case text
    /// Person name input with word capitalization
    case name
    
    // MARK: - Computed Properties
    
    /// Keyboard type appropriate for the field type.
    /// 
    /// - Returns: UIKeyboardType optimized for the input type
    var keyboardType: UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .password, .text, .name:
            return .default
        }
    }
    
    /// Content type for autofill and input suggestions.
    /// 
    /// - Returns: UITextContentType for system integration, or nil for generic text
    var contentType: UITextContentType? {
        switch self {
        case .email:
            return .emailAddress
        case .password:
            return .password
        case .name:
            return .name
        case .text:
            return nil
        }
    }
    
    /// Autocapitalization behavior for the field type.
    /// 
    /// - Returns: TextInputAutocapitalization setting appropriate for the content
    var autocapitalization: TextInputAutocapitalization {
        switch self {
        case .email, .password:
            return .never
        case .name:
            return .words
        case .text:
            return .sentences
        }
    }
}