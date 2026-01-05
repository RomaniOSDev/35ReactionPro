//
//  ReactionSession.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation

struct ReactionSession: Identifiable, Codable {
    let id: UUID
    var testId: UUID
    var startTime: Date
    var endTime: Date
    var results: ReactionResults
    var conditions: SessionConditions
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    var performanceScore: Double {
        results.calculatePerformanceScore(for: conditions.fatigueLevel)
    }
    
    init(id: UUID = UUID(), testId: UUID, startTime: Date, endTime: Date, results: ReactionResults, conditions: SessionConditions) {
        self.id = id
        self.testId = testId
        self.startTime = startTime
        self.endTime = endTime
        self.results = results
        self.conditions = conditions
    }
}

struct ReactionResults: Codable {
    var totalTrials: Int
    var correctTrials: Int
    var incorrectTrials: Int
    var missedTrials: Int
    var reactionTimes: [TimeInterval] // ms for each correct answer
    var falseStarts: Int // premature reactions
    
    var accuracy: Double {
        guard totalTrials > 0 else { return 0 }
        return Double(correctTrials) / Double(totalTrials) * 100
    }
    
    var averageReactionTime: TimeInterval? {
        guard !reactionTimes.isEmpty else { return nil }
        return reactionTimes.reduce(0, +) / Double(reactionTimes.count)
    }
    
    var consistencyScore: Double? { // standard deviation (lower = better)
        guard let average = averageReactionTime, !reactionTimes.isEmpty else { return nil }
        let variance = reactionTimes.reduce(0) { $0 + pow($1 - average, 2) } / Double(reactionTimes.count)
        return sqrt(variance)
    }
    
    func calculatePerformanceScore(for fatigueLevel: Int) -> Double {
        var score = 0.0
        
        // Accuracy component (0-50 points)
        score += accuracy * 0.5
        
        // Speed component (0-30 points)
        if let avgTime = averageReactionTime {
            let speedScore = max(0, 500 - avgTime) / 10 // faster = better
            score += min(speedScore, 30)
        }
        
        // Stability component (0-20 points)
        if let consistency = consistencyScore {
            let stabilityScore = max(0, 100 - consistency * 10) // less deviation = better
            score += min(stabilityScore, 20)
        }
        
        // Penalty for false starts
        score -= Double(falseStarts) * 2
        
        // Fatigue correction
        let fatiguePenalty = Double(fatigueLevel) * 0.5
        score = max(0, score - fatiguePenalty)
        
        return min(score, 100.0)
    }
    
    init(totalTrials: Int = 0, correctTrials: Int = 0, incorrectTrials: Int = 0, missedTrials: Int = 0, reactionTimes: [TimeInterval] = [], falseStarts: Int = 0) {
        self.totalTrials = totalTrials
        self.correctTrials = correctTrials
        self.incorrectTrials = incorrectTrials
        self.missedTrials = missedTrials
        self.reactionTimes = reactionTimes
        self.falseStarts = falseStarts
    }
}

struct SessionConditions: Codable {
    var timeOfDay: TimeOfDay
    var fatigueLevel: Int // 1-10
    var distractionLevel: Int // 1-5
    var handUsed: HandPreference
    var preWorkout: Bool
    
    var idealConditions: Bool {
        fatigueLevel <= 3 && distractionLevel <= 2
    }
    
    init(timeOfDay: TimeOfDay = .afternoon, fatigueLevel: Int = 3, distractionLevel: Int = 2, handUsed: HandPreference = .right, preWorkout: Bool = false) {
        self.timeOfDay = timeOfDay
        self.fatigueLevel = fatigueLevel
        self.distractionLevel = distractionLevel
        self.handUsed = handUsed
        self.preWorkout = preWorkout
    }
}

enum TimeOfDay: String, CaseIterable, Codable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"
}

enum HandPreference: String, CaseIterable, Codable {
    case right = "Right"
    case left = "Left"
    case both = "Both"
}



