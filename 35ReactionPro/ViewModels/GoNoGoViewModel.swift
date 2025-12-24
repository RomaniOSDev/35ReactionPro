//
//  GoNoGoViewModel.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation
import SwiftUI
import Combine

class GoNoGoViewModel: ObservableObject {
    @Published var test: ReactionTest
    @Published var isRunning: Bool = false
    @Published var currentStimulus: StimulusType?
    @Published var stimulusPosition: CGPoint = .zero
    @Published var showStimulus: Bool = false
    @Published var isTarget: Bool = false
    @Published var results: ReactionResults = ReactionResults()
    @Published var trialCount: Int = 0
    @Published var maxTrials: Int = 20
    @Published var feedbackMessage: String = ""
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
        
        showStimulus = false
        feedbackMessage = ""
        
        let delay = stimulusGenerator.getDelay(for: test.difficulty)
        let screenSize = UIScreen.main.bounds.size
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.presentStimulus(screenSize: screenSize)
        }
    }
    
    private func presentStimulus(screenSize: CGSize) {
        guard isRunning else { return }
        
        // Randomly choose target or distractor
        isTarget = Bool.random()
        
        let generated = stimulusGenerator.generateStimulus(
            for: test,
            difficulty: test.difficulty,
            screenSize: screenSize
        )
        
        currentStimulus = isTarget ? test.targetStimuli.first : test.distractorStimuli?.first
        stimulusPosition = generated.position
        
        withAnimation(.spring(response: 0.1, dampingFraction: 0.6)) {
            showStimulus = true
        }
    }
    
    func handleTap(at location: CGPoint) {
        guard isRunning else {
            results.falseStarts += 1
            return
        }
        
        let threshold: CGFloat = 100
        let distance = sqrt(pow(location.x - stimulusPosition.x, 2) + pow(location.y - stimulusPosition.y, 2))
        
        results.totalTrials += 1
        
        if distance < threshold {
            if isTarget {
                // Correct: tapped on Go stimulus
                results.correctTrials += 1
                feedbackMessage = "Correct!"
            } else {
                // Error: tapped on No-Go stimulus
                results.incorrectTrials += 1
                feedbackMessage = "Error! Don't tap red"
            }
        } else {
            if isTarget {
                // Missed target
                results.missedTrials += 1
                feedbackMessage = "Missed"
            } else {
                // Correct: didn't tap No-Go
                results.correctTrials += 1
                feedbackMessage = "Good restraint"
            }
        }
        
        trialCount += 1
        
        withAnimation {
            showStimulus = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.startNextTrial()
        }
    }
    
    func endTest() {
        isRunning = false
        showStimulus = false
        
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

