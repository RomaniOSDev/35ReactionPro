//
//  StimulusGenerator.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation
import SwiftUI
import Combine

class StimulusGenerator: ObservableObject {
    private var lastStimulusTime: Date?
    private let minDelay: TimeInterval = 0.5
    
    func generateStimulus(for test: ReactionTest, difficulty: DifficultyLevel, screenSize: CGSize) -> (stimulus: StimulusType, position: CGPoint, isTarget: Bool) {
        let now = Date()
        lastStimulusTime = now
        
        // Choose stimulus type (target or distractor)
        let isTarget = Bool.random()
        let stimulusType: StimulusType
        
        if isTarget {
            stimulusType = test.targetStimuli.randomElement() ?? .colorGreen
        } else {
            stimulusType = test.distractorStimuli?.randomElement() ?? .colorRed
        }
        
        // Random position on screen (80% of area)
        let position = CGPoint(
            x: CGFloat.random(in: 0.1...0.9) * screenSize.width,
            y: CGFloat.random(in: 0.1...0.9) * screenSize.height
        )
        
        return (stimulusType, position, isTarget)
    }
    
    func getDelay(for difficulty: DifficultyLevel) -> TimeInterval {
        let delayRange = difficulty.stimulusDelayRange
        return Double.random(in: delayRange)
    }
}



