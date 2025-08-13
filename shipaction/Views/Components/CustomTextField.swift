//
//  CustomTextField.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI


// MARK: - Custom Text Field Component
/// Reusable custom text field component with validation and modern design
struct CustomTextField: View {
    
    // MARK: - Properties
    let title: String
    let placeholder: String
    @Binding var text: String
    let type: TextFieldType
    let isSecure: Bool
    let validationMessage: String?
    let showValidation: Bool
    @State private var isSecureVisible = false
    
    // MARK: - Computed Properties
    private var hasError: Bool {
        showValidation && validationMessage != nil
    }
    
    private var fieldStyle: FieldStyle {
        hasError ? .error : .normal
    }
    
    private struct FieldStyle {
        let borderColor: Color
        let backgroundColor: Color
        let shadowColor: Color
        let shadowRadius: CGFloat
        let shadowOffset: CGSize
        
        static let normal = FieldStyle(
            borderColor: Color(.systemGray4),
            backgroundColor: Color(.systemBackground),
            shadowColor: Color(.systemGray).opacity(0.08),
            shadowRadius: 2,
            shadowOffset: CGSize(width: 0, height: 1)
        )
        
        static let error = FieldStyle(
            borderColor: AppConstants.Colors.primary,
            backgroundColor: AppConstants.Colors.primary.opacity(0.06),
            shadowColor: AppConstants.Colors.primary.opacity(0.15),
            shadowRadius: 8,
            shadowOffset: CGSize(width: 0, height: 3)
        )
    }
    
    // MARK: - Initialization
    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        type: TextFieldType = .text,
        isSecure: Bool = false,
        validationMessage: String? = nil,
        showValidation: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.type = type
        self.isSecure = isSecure
        self.validationMessage = validationMessage
        self.showValidation = showValidation
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Field Title
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(hasError ? fieldStyle.borderColor : Color(.label))
            
            // Text Field Container
            HStack(spacing: 12) {
                // Input Field
                Group {
                    if isSecure && !isSecureVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .textInputAutocapitalization(type.autocapitalization)
                .keyboardType(type.keyboardType)
                .textContentType(type.contentType)
                .autocorrectionDisabled()
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .foregroundColor(Color(.label))
                .tint(.primary)
                .accessibilityLabel(title)
                .accessibilityValue(text.isEmpty ? "Empty field" : text)
                .accessibilityHint("Double tap to edit \(title.lowercased())")
                .accessibilityIdentifier("\(title.lowercased().replacingOccurrences(of: " ", with: "_"))_textfield")
                
                // Password visibility toggle
                if isSecure {
                    Button(action: toggleSecureVisibility) {
                        Image(systemName: isSecureVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color(.systemGray2))
                            .font(.system(size: 16, weight: .medium))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contentShape(Rectangle())
                    .accessibilityLabel(isSecureVisible ? "Hide password" : "Show password")
                    .accessibilityHint("Toggles password visibility")
                    .accessibilityAddTraits(.isButton)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(fieldStyle.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(fieldStyle.borderColor, lineWidth: 2.0)
                    )
                    .shadow(
                        color: fieldStyle.shadowColor,
                        radius: fieldStyle.shadowRadius,
                        x: fieldStyle.shadowOffset.width,
                        y: fieldStyle.shadowOffset.height
                    )
            )
            .animation(.easeOut(duration: 0.25), value: hasError)
            
            // Validation Message
            if showValidation, let validationMessage = validationMessage {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.octagon.fill")
                        .foregroundStyle(AppConstants.Colors.primary)
                        .font(.system(size: 12, weight: .medium))
                    
                    Text(validationMessage)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(AppConstants.Colors.primary)
                }
                .padding(.top, 2)
                .transition(.opacity.combined(with: .scale(scale: 0.95)).combined(with: .offset(y: -5)))
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Toggles secure text visibility
    private func toggleSecureVisibility() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isSecureVisible.toggle()
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 24) {
        CustomTextField(
            title: "Email",
            placeholder: "E-posta adresinizi girin",
            text: .constant(""),
            type: .email
        )
        
        CustomTextField(
            title: "Password",
            placeholder: "Enter your password",
            text: .constant(""),
            type: .password,
            isSecure: true
        )
        
        CustomTextField(
            title: "Name",
            placeholder: "Enter your name",
            text: .constant("John Doe"),
            type: .name
        )
        
        CustomTextField(
            title: "Email (Hatalı)",
            placeholder: "E-posta adresinizi girin",
            text: .constant("invalid-email"),
            type: .email,
            validationMessage: "Geçerli bir email adresi girin",
            showValidation: true
        )
    }
    .padding()
} 