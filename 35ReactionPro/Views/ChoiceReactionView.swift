//
//  ChoiceReactionView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI

struct ChoiceReactionView: View {
    @StateObject private var viewModel: ChoiceReactionViewModel
    @Environment(\.dismiss) var dismiss
    
    init(test: ReactionTest) {
        _viewModel = StateObject(wrappedValue: ChoiceReactionViewModel(test: test))
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
                
                // Stimuli
                if viewModel.showStimuli {
                    ForEach(Array(viewModel.stimuli.enumerated()), id: \.offset) { index, stimulus in
                        Circle()
                            .fill(stimulus.type.color)
                            .frame(width: 80, height: 80)
                            .position(stimulus.position)
                            .shadow(color: stimulus.type.color.opacity(0.8), radius: 20)
                            .overlay(
                                Circle()
                                    .stroke(stimulus.isTarget ? Color.accentGreen : Color.accentRed, lineWidth: 3)
                            )
                    }
                }
                
                // Feedback
                if let feedbackColor = viewModel.feedbackColor {
                    VStack {
                        Text(feedbackColor == .accentGreen ? "Correct!" : feedbackColor == .accentRed ? "Wrong!" : "Missed")
                            .font(.system(size: 32, weight: .bold))
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
}

#Preview {
    ChoiceReactionView(test: DefaultTests.tests[1])
}



