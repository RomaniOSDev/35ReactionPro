//
//  SettingsView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                List {
                    Section {
                        settingsRow(
                            icon: "star.fill",
                            title: "Rate Us",
                            iconColor: .signalYellow
                        ) {
                            rateApp()
                        }
                        
                        settingsRow(
                            icon: "lock.shield.fill",
                            title: "Privacy Policy",
                            iconColor: .signalBlue
                        ) {
                            openPrivacyPolicy()
                        }
                        
                        settingsRow(
                            icon: "doc.text.fill",
                            title: "Terms of Service",
                            iconColor: .accentGreen
                        ) {
                            openTermsOfService()
                        }
                    }
                    .listRowBackground(Color.neutralGray.opacity(0.2))
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Settings")
            .foregroundColor(.textPrimary)
        }
    }
    
    private func settingsRow(
        icon: String,
        title: String,
        iconColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(iconColor)
                    .frame(width: 30)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding(.vertical, 8)
        }
    }
    
    private func rateApp() {
        // App Store URL - replace with your actual app ID
        SKStoreReviewController.requestReview()
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/14ac4b0a-34d4-44ac-84fb-11e602d5943c") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTermsOfService() {
        if let url = URL(string: "https://www.termsfeed.com/live/9f2a7ac7-48f8-443b-88d1-b0c99cc73059") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}

