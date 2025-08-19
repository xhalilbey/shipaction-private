//
//  OnboardingView.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI

// MARK: - Onboarding View

/// Main onboarding interface that guides users through app introduction.
/// 
/// This view presents a series of informational screens using a TabView
/// with custom navigation controls. Follows MVVM pattern with proper
/// separation of concerns and UI logic handled in the ViewModel.
struct OnboardingView: View {
    
    // MARK: - Properties
    
    /// ViewModel managing onboarding state and navigation logic
    @State private var viewModel: OnboardingViewModel
    
    /// Animation states for smooth transitions
    @State private var contentOffset: CGFloat = 50
    @State private var contentOpacity: Double = 0
    @State private var iconScale: CGFloat = 0.8
    @State private var backgroundOffset: CGFloat = 100
    
    // MARK: - Initialization
    
    init(viewModel: OnboardingViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    /// Environment value for safe area layout calculations
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    /// Environment dependencies
    @Environment(DependencyContainer.self) private var dependencies
    
    /// Color scheme environment
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Clean background (same as main app)
                AppConstants.Colors.dynamicBackground(colorScheme)
                .ignoresSafeArea()
                .offset(x: backgroundOffset)
                .animation(.easeInOut(duration: 1.5), value: backgroundOffset)
                

                
                VStack(spacing: 0) {
                    // Top spacing
                    Spacer()
                        .frame(height: geometry.safeAreaInsets.top + AppConstants.UI.verticalPadding)
                    
                    // Main content with smooth animations
                    TabView(selection: $viewModel.currentStepIndex) {
                        ForEach(Array(OnboardingStep.steps.enumerated()), id: \.element.id) { index, step in
                            
                            if index == viewModel.totalSteps - 1 {
                                AuthenticationStepView(
                                    step: step, 
                                    geometry: geometry,
                                    contentOpacity: contentOpacity,
                                    iconScale: iconScale,
                                    contentOffset: contentOffset
                                )
                                .tag(index)
                            } else {
                                OnboardingStepView(
                                    step: step, 
                                    geometry: geometry,
                                    contentOpacity: contentOpacity,
                                    iconScale: iconScale,
                                    contentOffset: contentOffset
                                )
                                .tag(index)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0), value: viewModel.currentStepIndex)
                    .frame(height: geometry.size.height * 0.68)
                    .onChange(of: viewModel.currentStepIndex) { oldValue, newValue in
                        // Trigger content animations on step change
                        withAnimation(.easeOut(duration: 0.3)) {
                            contentOpacity = 0
                            iconScale = 0.8
                            contentOffset = 30
                        }
                        
                        // Animate content in after a brief delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                contentOpacity = 1
                                iconScale = 1.0
                                contentOffset = 0
                            }
                        }
                    }
                    
                    // Page indicators (except on last step)
                    if !viewModel.isLastStep {
                        pageIndicators
                    }
                    
                    // Footer content based on ViewModel state
                    footerContent(geometry: geometry)
                }
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
        .onAppear {
            // Initial animation on view appear
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                contentOpacity = 1
                iconScale = 1.0
                contentOffset = 0
                backgroundOffset = 0
            }
        }
        .sheet(isPresented: $viewModel.showSignInSheet) {
            UberSignInSheet(viewModel: dependencies.makeAuthenticationViewModel())
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.showCreateAccountSheet) {
            UberCreateAccountSheet(viewModel: dependencies.makeAuthenticationViewModel())
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - View Components
    

    
    /// Page indicator dots with smooth animations
    private var pageIndicators: some View {
        HStack(spacing: 12) {
            ForEach(Array(OnboardingStep.steps.enumerated()), id: \.element.id) { index, step in
                ZStack {
                    // Background circle
                    Circle()
                        .fill(AppConstants.Colors.subtleBorder)
                        .frame(width: 8, height: 8)
                    
                    // Active indicator
                    Circle()
                        .fill(AppConstants.Colors.primary)
                        .frame(width: index == viewModel.currentStepIndex ? 12 : 8, 
                               height: index == viewModel.currentStepIndex ? 12 : 8)
                        .opacity(index == viewModel.currentStepIndex ? 1.0 : 0.0)
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.currentStepIndex)
            }
        }
        .padding(.top, AppConstants.UI.compactPadding)
        .opacity(contentOpacity)
        .offset(y: contentOffset * 0.5)
    }
    
    /// Footer content based on ViewModel state
    @ViewBuilder
    private func footerContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            switch viewModel.footerStyle {
            case .continue:
                continueFooter
            case .navigation:
                navigationFooter
            case .authentication:
                authenticationFooter
            }
        }
        .frame(height: 130, alignment: .bottom)
        .padding(.bottom, max(geometry.safeAreaInsets.bottom, AppConstants.UI.compactPadding))
    }
    
    /// Continue button footer for first step
    private var continueFooter: some View {
        UnifiedButton(
            title: "Get Started",
            style: .primary
        ) {
            viewModel.nextStep()
        }
        .frame(height: AppConstants.UI.buttonHeight)
        .padding(.horizontal, AppConstants.UI.largePadding)
    }
    
    /// Navigation footer with prev/next buttons
    private var navigationFooter: some View {
        HStack {
            // Previous button
            Button(action: {
                viewModel.previousStep()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppConstants.Colors.primary)
                    .frame(width: 54, height: 54)
                    .background(AppConstants.Colors.dynamicCardBackground(colorScheme))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
            }
            .padding(.leading, AppConstants.UI.horizontalPadding)
            
            Spacer()
            
            // Next button
            Button(action: {
                viewModel.nextStep()
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 54, height: 54)
                    .background(AppConstants.Colors.primary)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            }
            .padding(.trailing, AppConstants.UI.horizontalPadding)
        }
    }
    
    /// Authentication footer with sign in/create buttons
    private var authenticationFooter: some View {
        VStack(spacing: AppConstants.UI.verticalPadding) {
            HStack(spacing: AppConstants.UI.compactSpacing) {
                UnifiedButton(
                    title: "Sign In",
                    style: .secondaryWhite
                ) {
                    viewModel.showSignIn()
                }
                .frame(height: AppConstants.UI.buttonHeight)
                
                UnifiedButton(
                    title: "Create Account",
                    style: .primary
                ) {
                    viewModel.showCreateAccount()
                }
                .frame(height: AppConstants.UI.buttonHeight)
            }
            
                            Button(action: {
                    Task {
                        await viewModel.createDemoUserAndComplete()
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "applelogo")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                        
                        Text("Apple ile giriş yapın")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .foregroundColor(AppConstants.Colors.primary)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppConstants.Colors.dynamicBackground(colorScheme))
                            .stroke(AppConstants.Colors.primary, lineWidth: 1.5)
                    )
                }
                .frame(height: AppConstants.UI.buttonHeight)
        }
        .padding(.horizontal, AppConstants.UI.largePadding)
    }
}

// MARK: - Onboarding Step View

/// Displays individual onboarding step content with consistent layout.
/// 
/// This component renders a single onboarding step including icon,
/// title, and description text with Apple-style visual design.
struct OnboardingStepView: View {
    /// The onboarding step data to display
    let step: OnboardingStep
    
    /// Geometry proxy for responsive layout calculations
    let geometry: GeometryProxy
    
    /// Animation properties passed from parent
    let contentOpacity: Double
    let iconScale: CGFloat
    let contentOffset: CGFloat
    
    /// Color scheme environment
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Fixed top spacer for consistent icon positioning
            Spacer()
                .frame(height: geometry.size.height * 0.15)
            
            // Icon with Apple-style design and animation
            iconSection
                .scaleEffect(iconScale)
                .opacity(contentOpacity)
            
            // Fixed spacing after icon
            Spacer()
                .frame(height: 40)
            
            // Content with animation
            contentSection
                .opacity(contentOpacity)
                .offset(y: contentOffset)
            
            // Bottom spacer
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppConstants.UI.horizontalPadding)
    }
    
    // MARK: - View Components
    
    private var iconSection: some View {
        ZStack {
            // Base balloon using card background tone with teal glows
            Circle()
                .fill(AppConstants.Colors.dynamicCardBackground(colorScheme))
                .frame(width: 180, height: 180)
                .shadow(color: AppConstants.Colors.primary.opacity(0.22), radius: 28, x: 0, y: 0)
                .shadow(color: AppConstants.Colors.primary.opacity(0.11), radius: 70, x: 0, y: 0)
                .shadow(color: AppConstants.Colors.primary.opacity(0.06), radius: 120, x: 0, y: 0)

            // Soft inner dome
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.70),
                            AppConstants.Colors.surfaceStrong.opacity(0.96)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 156, height: 156)

            // Icon with brand color
            Image(systemName: step.iconName)
                .font(.system(size: 48, weight: .semibold, design: .rounded))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(AppConstants.Colors.primary)
                .shadow(color: AppConstants.Colors.primary.opacity(0.2), radius: 2, x: 0, y: 1)
        }
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    private var contentSection: some View {
        VStack(spacing: AppConstants.UI.standardPadding) {
            Text(step.title)
                .font(.system(size: AppConstants.Typography.title1, weight: .bold, design: .rounded))
                .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
                .multilineTextAlignment(.center)
            
            Text(step.description)
                .font(.system(size: AppConstants.Typography.body, weight: .regular, design: .rounded))
                .foregroundStyle(AppConstants.Colors.dynamicSecondaryText(colorScheme))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .lineSpacing(AppConstants.Typography.bodyLineSpacing)
                .padding(.horizontal, 28)
        }
    }
}

// MARK: - Authentication Step View

/// Final onboarding step presenting authentication options.
/// 
/// This specialized view maintains the same visual structure as other
/// onboarding steps while providing authentication entry points.
struct AuthenticationStepView: View {
    /// The onboarding step data to display
    let step: OnboardingStep
    
    /// Geometry proxy for responsive layout calculations
    let geometry: GeometryProxy
    
    /// Animation properties passed from parent
    let contentOpacity: Double
    let iconScale: CGFloat
    let contentOffset: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            // Fixed top spacer for consistent positioning
            Spacer()
                .frame(height: geometry.size.height * 0.15)
            
            // Icon section with animation
            ZStack {
                // Base balloon using card background tone with teal glows
                Circle()
                    .fill(AppConstants.Colors.surfaceStrong)
                    .frame(width: 160, height: 160)
                    .shadow(color: AppConstants.Colors.primary.opacity(0.18), radius: 22, x: 0, y: 0)
                    .shadow(color: AppConstants.Colors.primary.opacity(0.10), radius: 44, x: 0, y: 0)
                    .shadow(color: AppConstants.Colors.primary.opacity(0.06), radius: 68, x: 0, y: 0)

                // Soft inner dome
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.55),
                                AppConstants.Colors.surfaceStrong.opacity(0.95)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 140, height: 140)

                // (Removed inner badge background to avoid extra border/edge)

                // Icon with brand color
                Image(systemName: step.iconName)
                    .font(.system(size: 52, weight: .semibold, design: .rounded))
                    .symbolRenderingMode(.hierarchical)
                .foregroundStyle(AppConstants.Colors.primary)
                    .shadow(color: AppConstants.Colors.primary.opacity(0.2), radius: 2, x: 0, y: 1)
            }
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
            .scaleEffect(iconScale)
            .opacity(contentOpacity)
            
            // Fixed spacing after icon
            Spacer()
                .frame(height: 40)
            
            // Content section with animation
            VStack(spacing: AppConstants.UI.standardPadding) {
                Text(step.title)
                    .font(.system(size: AppConstants.Typography.title1, weight: .bold, design: .rounded))
                    .foregroundStyle(AppConstants.Colors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(step.description)
                    .font(.system(size: AppConstants.Typography.body, weight: .regular, design: .rounded))
                    .foregroundStyle(AppConstants.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(AppConstants.Typography.bodyLineSpacing)
                    .padding(.horizontal, 28)
            }
            .opacity(contentOpacity)
            .offset(y: contentOffset)
            
            // Bottom spacer
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppConstants.UI.horizontalPadding)
    }
}

// MARK: - Preview

#Preview {
    let navigationManager = NavigationManager()
    let dependencies = DependencyContainer(navigationManager: navigationManager)
    
    return OnboardingView(viewModel: dependencies.makeOnboardingViewModel())
        .environment(dependencies)
} 