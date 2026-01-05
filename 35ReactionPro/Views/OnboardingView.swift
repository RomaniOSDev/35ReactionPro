//
//  OnboardingView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                onboardingPage1
                    .tag(0)
                
                onboardingPage2
                    .tag(1)
                
                onboardingPage3
                    .tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            VStack {
                Spacer()
                
                if currentPage == 2 {
                    Button(action: {
                        completeOnboarding()
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentGreen)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                } else {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentGreen)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
    }
    
    private var onboardingPage1: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "bolt.fill")
                .font(.system(size: 80))
                .foregroundColor(.accentGreen)
                .shadow(color: .accentGreen.opacity(0.5), radius: 20)
            
            Text("Welcome to Reaction Pro")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Professional reaction training for athletes")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
    
    private var onboardingPage2: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "target")
                .font(.system(size: 80))
                .foregroundColor(.signalBlue)
                .shadow(color: .signalBlue.opacity(0.5), radius: 20)
            
            Text("Train Your Reaction Speed")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Improve your reaction time with various tests designed for professional athletes")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
    
    private var onboardingPage3: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 80))
                .foregroundColor(.accentGreen)
                .shadow(color: .accentGreen.opacity(0.5), radius: 20)
            
            Text("Track Your Progress")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Monitor your improvement with detailed analytics and performance metrics")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        withAnimation {
            isOnboardingComplete = true
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}



