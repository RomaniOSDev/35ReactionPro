//
//  ReactionAnalyzer.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation

struct ReactionAnalyzer {
    static func evaluateSession(_ session: ReactionSession, profile: ReactionProfile) -> Evaluation {
        let results = session.results
        
        var evaluation = Evaluation()
        
        // Speed evaluation
        if let avgTime = results.averageReactionTime {
            if avgTime <= profile.bestReactionTime {
                evaluation.speedRating = .excellent
                evaluation.comments.append("New speed record! \(Int(avgTime))ms")
            } else if avgTime <= profile.baselineReactionTime {
                evaluation.speedRating = .good
                evaluation.comments.append("Good speed: \(Int(avgTime))ms")
            } else {
                evaluation.speedRating = .needsImprovement
                evaluation.comments.append("Speed slowed down, possibly fatigue")
            }
        }
        
        // Accuracy evaluation
        if results.accuracy >= 95 {
            evaluation.accuracyRating = .excellent
            evaluation.comments.append("Perfect accuracy: \(Int(results.accuracy))%")
        } else if results.accuracy >= 85 {
            evaluation.accuracyRating = .good
            evaluation.comments.append("Good accuracy: \(Int(results.accuracy))%")
        } else {
            evaluation.accuracyRating = .needsImprovement
            evaluation.comments.append("Accuracy can be improved: \(Int(results.accuracy))%")
        }
        
        // Consistency evaluation
        if let consistency = results.consistencyScore {
            if consistency < 50 {
                evaluation.consistencyRating = .excellent
                evaluation.comments.append("High reaction stability")
            } else if consistency < 100 {
                evaluation.consistencyRating = .good
            } else {
                evaluation.consistencyRating = .needsImprovement
                evaluation.comments.append("Reactions unstable, need concentration")
            }
        }
        
        // Recommendations
        if results.falseStarts > 3 {
            evaluation.recommendations.append("Too many false starts. Work on impulse control")
        }
        
        if session.conditions.fatigueLevel > 5 {
            evaluation.recommendations.append("High fatigue level. Rest before reaction training")
        }
        
        return evaluation
    }
}

