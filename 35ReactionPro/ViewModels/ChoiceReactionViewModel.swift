//
//  ChoiceReactionViewModel.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation
import SwiftUI
import Combine

class ChoiceReactionViewModel: ObservableObject {
    @Published var test: ReactionTest
    @Published var isRunning: Bool = false
    @Published var stimuli: [(type: StimulusType, position: CGPoint, isTarget: Bool)] = []
    @Published var results: ReactionResults = ReactionResults()
    @Published var trialCount: Int = 0
    @Published var maxTrials: Int = 15
    @Published var showStimuli: Bool = false
    @Published var feedbackColor: Color?
    @Published var sessionStartTime: Date?
    
    private let stimulusGenerator = StimulusGenerator()
    
    init(test: ReactionTest) {
        self.test = test
    }
    
    func startTest() {
        isRunning = true
        trialCount = 0
        results = ReactionResults()
        sessionStartTime = Date()
        startNextTrial()
    }
    
    func startNextTrial() {
        guard trialCount < maxTrials else {
            endTest()
            return
        }
        
        showStimuli = false
        feedbackColor = nil
        
        let delay = stimulusGenerator.getDelay(for: test.difficulty)
        let screenSize = UIScreen.main.bounds.size
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.presentStimuli(screenSize: screenSize)
        }
    }
    
    private func presentStimuli(screenSize: CGSize) {
        guard isRunning else { return }
        
        var newStimuli: [(type: StimulusType, position: CGPoint, isTarget: Bool)] = []
        
        // Generate target stimulus - always from targetStimuli
        let targetType = test.targetStimuli.randomElement() ?? test.targetStimuli.first ?? .colorGreen
        let targetPosition = CGPoint(
            x: CGFloat.random(in: 0.1...0.9) * screenSize.width,
            y: CGFloat.random(in: 0.1...0.9) * screenSize.height
        )
        newStimuli.append((targetType, targetPosition, true))
        
        // Generate distractor stimuli - always from distractorStimuli
        if let distractors = test.distractorStimuli, !distractors.isEmpty {
            for _ in 0..<2 {
                let distractorType = distractors.randomElement() ?? distractors.first ?? .colorRed
                let distractorPosition = CGPoint(
                    x: CGFloat.random(in: 0.1...0.9) * screenSize.width,
                    y: CGFloat.random(in: 0.1...0.9) * screenSize.height
                )
                newStimuli.append((distractorType, distractorPosition, false))
            }
        }
        
        stimuli = newStimuli.shuffled()
        
        withAnimation(.spring(response: 0.1, dampingFraction: 0.6)) {
            showStimuli = true
        }
    }
    
    func handleTap(at location: CGPoint) {
        guard isRunning, showStimuli else {
            results.falseStarts += 1
            return
        }
        
        // Find tapped stimulus
        var tappedStimulus: (type: StimulusType, position: CGPoint, isTarget: Bool)?
        let threshold: CGFloat = 80
        
        for stimulus in stimuli {
            let distance = sqrt(pow(location.x - stimulus.position.x, 2) + pow(location.y - stimulus.position.y, 2))
            if distance < threshold {
                tappedStimulus = stimulus
                break
            }
        }
        
        results.totalTrials += 1
        
        if let tapped = tappedStimulus {
            // Check if tapped stimulus is in targetStimuli (correct answer)
            let isCorrect = test.targetStimuli.contains(tapped.type)
            
            if isCorrect {
                results.correctTrials += 1
                feedbackColor = .accentGreen
            } else {
                results.incorrectTrials += 1
                feedbackColor = .accentRed
            }
        } else {
            results.missedTrials += 1
            feedbackColor = .neutralGray
        }
        
        trialCount += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showStimuli = false
            self.feedbackColor = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.startNextTrial()
            }
        }
    }
    
    func endTest() {
        isRunning = false
        showStimuli = false
        
        if let startTime = sessionStartTime {
            let session = ReactionSession(
                testId: test.id,
                startTime: startTime,
                endTime: Date(),
                results: results,
                conditions: SessionConditions()
            )
            saveSession(session)
            
            // Increment streak
            NotificationCenter.default.post(
                name: NSNotification.Name("IncrementStreak"),
                object: nil
            )
        }
    }
    
    private func saveSession(_ session: ReactionSession) {
        var sessions = loadSessions()
        sessions.append(session)
        
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: "reactionSessions")
        }
    }
    
    private func loadSessions() -> [ReactionSession] {
        if let data = UserDefaults.standard.data(forKey: "reactionSessions"),
           let decoded = try? JSONDecoder().decode([ReactionSession].self, from: data) {
            return decoded
        }
        return []
    }
}

