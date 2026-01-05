//
//  Evaluation.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation

struct Evaluation {
    var speedRating: PerformanceRating = .average
    var accuracyRating: PerformanceRating = .average
    var consistencyRating: PerformanceRating = .average
    var comments: [String] = []
    var recommendations: [String] = []
}

enum PerformanceRating: String {
    case excellent = "Excellent"
    case good = "Good"
    case average = "Average"
    case needsImprovement = "Needs Improvement"
}



