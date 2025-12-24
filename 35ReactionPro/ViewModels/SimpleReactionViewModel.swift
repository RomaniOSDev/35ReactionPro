//
//  SimpleReactionViewModel.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation
import SwiftUI
import Combine

class SimpleReactionViewModel: ObservableObject {
    @Published var test: ReactionTest
    @Published var isRunning: Bool = false
    @Published var currentStimulus: StimulusType?
    @Published var stimulusPosition: CGPoint = .zero
    @Published var showStimulus: Bool = false
    @Published var reactionTime: TimeInterval?
    @Published var results: ReactionResults = ReactionResults()
    @Published var trialCount: Int = 0
    @Published var maxTrials: Int = 10
    @Published var startTime: Date?
    @Published var stimulusAppearTime: Date?
    @Published var showResult: Bool = false
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
        showResult = false
        startNextTrial()
    }
    
    func startNextTrial() {
        guard trialCount < maxTrials else {
            endTest()
            return
        }
        
        showStimulus = false
        reactionTime = nil
        
        let delay = stimulusGenerator.getDelay(for: test.difficulty)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.presentStimulus()
        }
    }
    
    private func presentStimulus() {
        guard isRunning else { return }
        
        let screenSize = UIScreen.main.bounds.size
        let generated = stimulusGenerator.generateStimulus(
            for: test,
            difficulty: test.difficulty,
            screenSize: screenSize
        )
        
        currentStimulus = generated.stimulus
        stimulusPosition = generated.position
        stimulusAppearTime = Date()
        
        withAnimation(.spring(response: 0.1, dampingFraction: 0.6)) {
            showStimulus = true
        }
    }
    
    func handleTap(at location: CGPoint) {
        guard isRunning, showStimulus, let appearTime = stimulusAppearTime else {
            // False start
            results.falseStarts += 1
            return
        }
        
        let tapTime = Date()
        let reaction = tapTime.timeIntervalSince(appearTime) * 1000 // convert to ms
        
        // Check if tap is near stimulus
        let distance = sqrt(pow(location.x - stimulusPosition.x, 2) + pow(location.y - stimulusPosition.y, 2))
        let threshold: CGFloat = 100
        
        if distance < threshold {
            // Correct tap
            results.totalTrials += 1
            results.correctTrials += 1
            results.reactionTimes.append(reaction)
            reactionTime = reaction
        } else {
            // Miss
            results.totalTrials += 1
            results.missedTrials += 1
        }
        
        trialCount += 1
        
        withAnimation {
            showStimulus = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
            
            showResult = true
            // Save session
            saveSession(session)
            
            // Update best time if needed
            if let bestTime = results.reactionTimes.min() {
                NotificationCenter.default.post(
                    name: NSNotification.Name("UpdateBestTime"),
                    object: nil,
                    userInfo: ["bestTime": bestTime]
                )
            }
            
            // Increment streak
            NotificationCenter.default.post(
                name: NSNotification.Name("IncrementStreak"),
                object: nil
            )
        }
    }
    
    private func saveSession(_ session: ReactionSession) {
        // Save to UserDefaults or CoreData
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

