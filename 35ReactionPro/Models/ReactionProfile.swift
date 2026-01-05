//
//  ReactionProfile.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation

struct ReactionProfile: Codable {
    var baselineReactionTime: TimeInterval // ms
    var bestReactionTime: TimeInterval
    var consistencyScore: Double // 0-100
    var dominantHand: HandPreference
    var optimalTimeOfDay: TimeOfDay?
    var fatigueImpact: Double // % slowdown when fatigued
    
    var reactionLevel: String {
        switch baselineReactionTime {
        case ..<180: return "Elite"
        case 180..<220: return "Advanced"
        case 220..<280: return "Intermediate"
        default: return "Beginner"
        }
    }
    
    init(baselineReactionTime: TimeInterval = 300, bestReactionTime: TimeInterval = 300, consistencyScore: Double = 50, dominantHand: HandPreference = .right, optimalTimeOfDay: TimeOfDay? = nil, fatigueImpact: Double = 15) {
        self.baselineReactionTime = baselineReactionTime
        self.bestReactionTime = bestReactionTime
        self.consistencyScore = consistencyScore
        self.dominantHand = dominantHand
        self.optimalTimeOfDay = optimalTimeOfDay
        self.fatigueImpact = fatigueImpact
    }
}

struct ProgressMetrics: Identifiable {
    let id: UUID
    var date: Date
    var averageReactionTime: TimeInterval
    var accuracy: Double
    var consistency: Double
    var testType: TestType
    var improvementFromBaseline: Double // %
    
    init(id: UUID = UUID(), date: Date, averageReactionTime: TimeInterval, accuracy: Double, consistency: Double, testType: TestType, improvementFromBaseline: Double) {
        self.id = id
        self.date = date
        self.averageReactionTime = averageReactionTime
        self.accuracy = accuracy
        self.consistency = consistency
        self.testType = testType
        self.improvementFromBaseline = improvementFromBaseline
    }
}



