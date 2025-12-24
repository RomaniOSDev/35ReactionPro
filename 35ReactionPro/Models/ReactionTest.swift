//
//  ReactionTest.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation
import SwiftUI

struct ReactionTest: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: TestType
    var description: String
    var difficulty: DifficultyLevel
    var duration: TimeInterval // seconds
    var targetStimuli: [StimulusType]
    var distractorStimuli: [StimulusType]? // distracting stimuli
    var instructions: [String]
    var successCriteria: SuccessCriteria
    
    var accentColor: Color {
        switch difficulty {
        case .beginner: return Color(hex: "14DB14")
        case .intermediate: return Color(hex: "FFFF00")
        case .advanced: return Color(hex: "FF0000")
        case .elite: return Color(hex: "FF00FF")
        }
    }
    
    init(id: UUID = UUID(), name: String, type: TestType, description: String, difficulty: DifficultyLevel, duration: TimeInterval, targetStimuli: [StimulusType], distractorStimuli: [StimulusType]? = nil, instructions: [String], successCriteria: SuccessCriteria) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.difficulty = difficulty
        self.duration = duration
        self.targetStimuli = targetStimuli
        self.distractorStimuli = distractorStimuli
        self.instructions = instructions
        self.successCriteria = successCriteria
    }
}

enum TestType: String, CaseIterable, Codable {
    case simpleReaction = "Simple Reaction"
    case choiceReaction = "Choice Reaction"
    case goNoGo = "Go/No-Go"
    case sequence = "Sequence"
    case anticipation = "Anticipation"
}

enum StimulusType: String, CaseIterable, Codable, Equatable {
    case visualCircle = "Circle"
    case visualSquare = "Square"
    case visualTriangle = "Triangle"
    case colorGreen = "Green"
    case colorRed = "Red"
    case colorBlue = "Blue"
    case soundHigh = "High Sound"
    case soundLow = "Low Sound"
    case soundClick = "Click"
    case haptic = "Vibration"
    
    var color: Color {
        switch self {
        case .colorGreen: return Color(hex: "14DB14")
        case .colorRed: return Color(hex: "FF0000")
        case .colorBlue: return Color(hex: "0088FF")
        case .visualCircle: return Color(hex: "FFFF00")
        default: return Color.white
        }
    }
}

enum DifficultyLevel: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case elite = "Elite"
    
    var stimulusDelayRange: ClosedRange<TimeInterval> {
        switch self {
        case .beginner: return 1.5...3.0
        case .intermediate: return 1.0...2.0
        case .advanced: return 0.5...1.5
        case .elite: return 0.2...0.8
        }
    }
    
    var reactionTimeThreshold: TimeInterval { // threshold for good reaction in ms
        switch self {
        case .beginner: return 400
        case .intermediate: return 300
        case .advanced: return 220
        case .elite: return 180
        }
    }
}

struct SuccessCriteria: Codable {
    var minAccuracy: Double // 0-100%
    var maxReactionTime: TimeInterval // ms
    var minScore: Int
}

