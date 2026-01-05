//
//  DefaultTests.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation

struct DefaultTests {
    static let tests: [ReactionTest] = [
        ReactionTest(
            name: "Lightning Reaction",
            type: .simpleReaction,
            description: "Tap the green circle as fast as possible",
            difficulty: .beginner,
            duration: 60,
            targetStimuli: [.visualCircle, .colorGreen],
            distractorStimuli: nil,
            instructions: ["Focus on the screen", "React instantly", "Don't anticipate timing"],
            successCriteria: SuccessCriteria(minAccuracy: 90, maxReactionTime: 400, minScore: 80)
        ),
        
        ReactionTest(
            name: "Color Choice",
            type: .choiceReaction,
            description: "React only to green, ignore red",
            difficulty: .intermediate,
            duration: 90,
            targetStimuli: [.colorGreen],
            distractorStimuli: [.colorRed],
            instructions: ["Tap only green", "Ignore red", "Be accurate and fast"],
            successCriteria: SuccessCriteria(minAccuracy: 85, maxReactionTime: 350, minScore: 85)
        ),
        
        ReactionTest(
            name: "Impulse Control",
            type: .goNoGo,
            description: "Tap green, restrain on red",
            difficulty: .advanced,
            duration: 120,
            targetStimuli: [.colorGreen],
            distractorStimuli: [.colorRed],
            instructions: ["React quickly to green", "Restrain on red", "Control impulses"],
            successCriteria: SuccessCriteria(minAccuracy: 80, maxReactionTime: 300, minScore: 90)
        ),
        
        ReactionTest(
            name: "Memory Sequence",
            type: .sequence,
            description: "Remember and repeat the sequence",
            difficulty: .intermediate,
            duration: 180,
            targetStimuli: [.colorGreen, .colorRed, .colorBlue],
            distractorStimuli: nil,
            instructions: ["Remember the sequence", "Repeat in the same order", "Difficulty will increase"],
            successCriteria: SuccessCriteria(minAccuracy: 75, maxReactionTime: 500, minScore: 70)
        )
    ]
}



