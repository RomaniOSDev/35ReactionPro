//
//  SequenceView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI

struct SequenceView: View {
    let test: ReactionTest
    @Environment(\.dismiss) var dismiss
    @State private var sequence: [StimulusType] = []
    @State private var userSequence: [StimulusType] = []
    @State private var showingSequence = false
    @State private var currentStep = 0
    @State private var score = 0
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text(test.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Score: \(score)")
                    .font(.title2)
                    .foregroundColor(.accentGreen)
                
                if showingSequence {
                    sequenceDisplay
                } else {
                    inputDisplay
                }
                
                Button(action: {
                    if showingSequence {
                        startInputPhase()
                    } else {
                        checkSequence()
                    }
                }) {
                    Text(showingSequence ? "Watch Sequence" : "Submit")
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
        .onAppear {
            generateSequence()
            showSequence()
        }
    }
    
    private var sequenceDisplay: some View {
        VStack(spacing: 20) {
            Text("Watch the sequence")
                .foregroundColor(.textSecondary)
            
            HStack(spacing: 15) {
                ForEach(Array(sequence.enumerated()), id: \.offset) { index, stimulus in
                    Circle()
                        .fill(stimulus.color)
                        .frame(width: 60, height: 60)
                        .opacity(index <= currentStep ? 1 : 0.3)
                }
            }
        }
    }
    
    private var inputDisplay: some View {
        VStack(spacing: 20) {
            Text("Repeat the sequence")
                .foregroundColor(.textSecondary)
            
            HStack(spacing: 15) {
                ForEach(test.targetStimuli, id: \.self) { stimulus in
                    Button(action: {
                        userSequence.append(stimulus)
                    }) {
                        Circle()
                            .fill(stimulus.color)
                            .frame(width: 60, height: 60)
                    }
                }
            }
            
            if !userSequence.isEmpty {
                HStack(spacing: 10) {
                    ForEach(Array(userSequence.enumerated()), id: \.offset) { index, stimulus in
                        Circle()
                            .fill(stimulus.color)
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
    }
    
    private func generateSequence() {
        sequence = (0..<3).map { _ in
            test.targetStimuli.randomElement() ?? .colorGreen
        }
    }
    
    private func showSequence() {
        showingSequence = true
        currentStep = 0
        userSequence = [] // Clear user sequence when showing new sequence
        
        for i in 0..<sequence.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.8) {
                withAnimation {
                    currentStep = i
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(sequence.count) * 0.8) {
            showingSequence = false
        }
    }
    
    private func startInputPhase() {
        showingSequence = false
        userSequence = []
    }
    
    private func checkSequence() {
        if userSequence == sequence {
            score += 1
            userSequence = [] // Clear user sequence before next level
            generateSequence()
            showSequence()
        } else {
            // Game over or retry
            userSequence = []
        }
    }
}

#Preview {
    SequenceView(test: DefaultTests.tests[3])
}

