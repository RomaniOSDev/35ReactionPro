//
//  ProfileView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = MainDashboardViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        profileHeader
                        reactionLevelCard
                        statsGrid
                        recommendationsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .foregroundColor(.textPrimary)
            .onAppear {
                viewModel.loadData()
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 15) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.accentGreen)
            
            Text("Reaction Profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
        }
    }
    
    private var reactionLevelCard: some View {
        VStack(spacing: 15) {
            Text("Current Level")
                .font(.headline)
                .foregroundColor(.textSecondary)
            
            Text(viewModel.profile.reactionLevel)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.accentGreen)
                .shadow(color: .accentGreen.opacity(0.5), radius: 10)
            
            HStack(spacing: 30) {
                VStack {
                    Text("Baseline")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    Text("\(Int(viewModel.profile.baselineReactionTime))ms")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
                
                VStack {
                    Text("Best")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    Text("\(Int(viewModel.profile.bestReactionTime))ms")
                        .font(.headline)
                        .foregroundColor(.accentGreen)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.neutralGray.opacity(0.2))
        )
    }
    
    private var statsGrid: some View {
        VStack(spacing: 15) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                statBox(title: "Consistency", value: "\(Int(viewModel.profile.consistencyScore))%", color: .signalBlue)
                statBox(title: "Fatigue Impact", value: "\(Int(viewModel.profile.fatigueImpact))%", color: .signalYellow)
                statBox(title: "Dominant Hand", value: viewModel.profile.dominantHand.rawValue, color: .accentGreen)
                statBox(title: "Optimal Time", value: viewModel.profile.optimalTimeOfDay?.rawValue ?? "N/A", color: .accentRed)
            }
        }
    }
    
    private func statBox(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.neutralGray.opacity(0.2))
        )
    }
    
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recommendations")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            recommendationCard(
                icon: "clock.fill",
                title: "Optimal Training Time",
                description: viewModel.profile.optimalTimeOfDay?.rawValue ?? "Track your sessions to find your best time"
            )
            
            recommendationCard(
                icon: "hand.raised.fill",
                title: "Hand Preference",
                description: "You're using \(viewModel.profile.dominantHand.rawValue.lowercased()) hand. Try training both!"
            )
        }
    }
    
    private func recommendationCard(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentGreen)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.neutralGray.opacity(0.2))
        )
    }
}

#Preview {
    ProfileView()
}

