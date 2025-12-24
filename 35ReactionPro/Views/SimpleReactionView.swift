//
//  SimpleReactionView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI

struct SimpleReactionView: View {
    @StateObject private var viewModel: SimpleReactionViewModel
    @Environment(\.dismiss) var dismiss
    
    init(test: ReactionTest) {
        _viewModel = StateObject(wrappedValue: SimpleReactionViewModel(test: test))
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if !viewModel.isRunning && !viewModel.showResult {
                // Start screen
                startScreen
            } else if viewModel.showResult {
                // Results screen
                resultsScreen
            } else {
                // Test screen
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
                // Background
                Color.appBackground
                
                // Stimulus
                if viewModel.showStimulus, let stimulus = viewModel.currentStimulus {
                    Circle()
                        .fill(stimulus.color)
                        .frame(width: 80, height: 80)
                        .position(viewModel.stimulusPosition)
                        .shadow(color: stimulus.color.opacity(0.8), radius: 20)
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Reaction time display
                if let reactionTime = viewModel.reactionTime {
                    VStack {
                        Text("\(Int(reactionTime))ms")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.accentGreen)
                            .shadow(color: .accentGreen.opacity(0.5), radius: 10)
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
    
    private var resultsScreen: some View {
        VStack(spacing: 30) {
            Text("Test Complete")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 20) {
                if let avgTime = viewModel.results.averageReactionTime {
                    resultRow(title: "Average Time", value: "\(Int(avgTime))ms", color: .accentGreen)
                }
                
                resultRow(title: "Accuracy", value: "\(Int(viewModel.results.accuracy))%", color: .accentGreen)
                
                resultRow(title: "Correct", value: "\(viewModel.results.correctTrials)", color: .accentGreen)
                
                resultRow(title: "Missed", value: "\(viewModel.results.missedTrials)", color: .accentRed)
                
                resultRow(title: "False Starts", value: "\(viewModel.results.falseStarts)", color: .signalYellow)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.neutralGray.opacity(0.2))
            )
            
            Button(action: {
                dismiss()
            }) {
                Text("Done")
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
    
    private func resultRow(title: String, value: String, color: Color) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.textSecondary)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

#Preview {
    SimpleReactionView(test: DefaultTests.tests[0])
}

