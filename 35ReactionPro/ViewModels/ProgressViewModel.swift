//
//  ProgressViewModel.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation
import SwiftUI
import Combine

class ProgressViewModel: ObservableObject {
    @Published var sessions: [ReactionSession] = []
    @Published var metrics: [ProgressMetrics] = []
    @Published var profile: ReactionProfile
    
    init() {
        self.profile = ReactionProfile()
        loadData()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "reactionSessions"),
           let decoded = try? JSONDecoder().decode([ReactionSession].self, from: data) {
            self.sessions = decoded
            calculateMetrics()
        }
        
        if let data = UserDefaults.standard.data(forKey: "reactionProfile"),
           let decoded = try? JSONDecoder().decode(ReactionProfile.self, from: data) {
            self.profile = decoded
        }
    }
    
    private func calculateMetrics() {
        metrics = sessions.map { session in
            let results = session.results
            let improvement = calculateImprovement(session: session)
            
            return ProgressMetrics(
                date: session.startTime,
                averageReactionTime: results.averageReactionTime ?? 0,
                accuracy: results.accuracy,
                consistency: results.consistencyScore ?? 0,
                testType: .simpleReaction, // Should be stored in session
                improvementFromBaseline: improvement
            )
        }
    }
    
    private func calculateImprovement(session: ReactionSession) -> Double {
        guard let avgTime = session.results.averageReactionTime else { return 0 }
        let baseline = profile.baselineReactionTime
        return ((baseline - avgTime) / baseline) * 100
    }
}

