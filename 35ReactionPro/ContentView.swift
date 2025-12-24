//
//  ContentView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        if hasCompletedOnboarding {
            TabView(selection: $selectedTab) {
                MainDashboardView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                ProgressAnalyticsView()
                    .tabItem {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Progress")
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                    .tag(3)
            }
            .accentColor(.accentGreen)
            .preferredColorScheme(.dark)
        } else {
            OnboardingView(isOnboardingComplete: $hasCompletedOnboarding)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
