//
//  GoNoGoView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI

struct GoNoGoView: View {
    @StateObject private var viewModel: GoNoGoViewModel
    @Environment(\.dismiss) var dismiss
    
    init(test: ReactionTest) {
        _viewModel = StateObject(wrappedValue: GoNoGoViewModel(test: test))
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if !viewModel.isRunning {
                startScreen
            } else {
                testScreen
            }
        }
    }
    
    private var startScreen: some View {
        VStack(spacing: 30) {
            Text(viewModel.test.name)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(viewModel.test.description)
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Instructions:")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                ForEach(viewModel.test.instructions, id: \.self) { instruction in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentGreen)
                        Text(instruction)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.neutralGray.opacity(0.2))
            )
            
            Button(action: {
                viewModel.startTest()
            }) {
                Text("Start Test")
                    .font(.headline)
                    .foregroundColor(.appBackground)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentGreen)
                    .cornerRadius(15)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var testScreen: some View {
        GeometryReader { geometry in
            ZStack {
                Color.appBackground
                
                // Stimulus
                if viewModel.showStimulus, let stimulus = viewModel.currentStimulus {
                    Circle()
                        .fill(stimulus.color)
                        .frame(width: 100, height: 100)
                        .position(viewModel.stimulusPosition)
                        .shadow(color: stimulus.color.opacity(0.8), radius: 25)
                        .overlay(
                            Circle()
                                .stroke(viewModel.isTarget ? Color.accentGreen : Color.accentRed, lineWidth: 4)
                        )
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Feedback
                if !viewModel.feedbackMessage.isEmpty {
                    VStack {
                        Text(viewModel.feedbackMessage)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(feedbackColor)
                            .shadow(color: feedbackColor.opacity(0.5), radius: 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Progress
                VStack {
                    HStack {
                        Text("Trial \(viewModel.trialCount)/\(viewModel.maxTrials)")
                            .foregroundColor(.textSecondary)
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { location in
                viewModel.handleTap(at: location)
            }
        }
    }
    
    private var feedbackColor: Color {
        if viewModel.feedbackMessage.contains("Correct") || viewModel.feedbackMessage.contains("Good") {
            return .accentGreen
        } else if viewModel.feedbackMessage.contains("Error") {
            return .accentRed
        } else {
            return .textSecondary
        }
    }
}

#Preview {
    GoNoGoView(test: DefaultTests.tests[2])
}

