//
//  MainDashboardView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI

struct MainDashboardView: View {
    @StateObject private var viewModel = MainDashboardViewModel()
    @State private var selectedTest: ReactionTest?
    
    let tests = DefaultTests.tests
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Status Display
                        statusCard
                        
                        // Best Result
                        bestResultCard
                        
                        // Quick Access Tests
                        quickAccessSection
                        
                        // Streak
                        streakCard
                    }
                    .padding()
                }
            }
            .navigationTitle("Reaction Pro")
            .foregroundColor(.textPrimary)
            .sheet(item: $selectedTest) { test in
                testView(for: test)
            }
        }
    }
    
    private var statusCard: some View {
        VStack(spacing: 15) {
            Text("Reaction Status")
                .font(.headline)
                .foregroundColor(.textSecondary)
            
            Text(viewModel.profile.reactionLevel)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.accentGreen)
                .shadow(color: .accentGreen.opacity(0.5), radius: 10)
            
            Text("\(Int(viewModel.profile.baselineReactionTime))ms baseline")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.neutralGray.opacity(0.3))
        )
    }
    
    private var bestResultCard: some View {
        VStack(spacing: 10) {
            Text("Best Time")
                .font(.headline)
                .foregroundColor(.textSecondary)
            
            Text("\(Int(viewModel.bestReactionTime))ms")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.accentGreen)
                .shadow(color: .accentGreen.opacity(0.5), radius: 15)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.accentGreen.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.accentGreen.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Tests")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(tests) { test in
                    testCard(test: test)
                }
            }
        }
    }
    
    private func testCard(test: ReactionTest) -> some View {
        Button(action: {
            selectedTest = test
        }) {
            VStack(alignment: .leading, spacing: 10) {
                Text(test.name)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text(test.description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
                
                HStack {
                    Text(test.difficulty.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(test.accentColor.opacity(0.3))
                        .foregroundColor(test.accentColor)
                        .cornerRadius(8)
                    
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.neutralGray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(test.accentColor.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    private var streakCard: some View {
        HStack {
            Image(systemName: "flame.fill")
                .foregroundColor(.accentRed)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text("Training Streak")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text("\(viewModel.currentStreak) days")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.accentRed)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.accentRed.opacity(0.1))
        )
    }
    
    @ViewBuilder
    private func testView(for test: ReactionTest) -> some View {
        switch test.type {
        case .simpleReaction:
            SimpleReactionView(test: test)
        case .choiceReaction:
            ChoiceReactionView(test: test)
        case .goNoGo:
            GoNoGoView(test: test)
        case .sequence:
            SequenceView(test: test)
        case .anticipation:
            AnticipationView(test: test)
        }
    }
}

#Preview {
    MainDashboardView()
}

