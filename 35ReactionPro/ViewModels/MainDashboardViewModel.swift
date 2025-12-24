//
//  MainDashboardViewModel.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import Foundation
import SwiftUI
import Combine

class MainDashboardViewModel: ObservableObject {
    @Published var profile: ReactionProfile
    @Published var recentSessions: [ReactionSession] = []
    @Published var currentStreak: Int = 0
    @Published var bestReactionTime: TimeInterval = 300
    
    init() {
        self.profile = ReactionProfile()
        loadData()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("UpdateBestTime"),
            object: nil,
            queue: .main
        ) { notification in
            if let bestTime = notification.userInfo?["bestTime"] as? TimeInterval {
                self.updateBestTime(bestTime)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("IncrementStreak"),
            object: nil,
            queue: .main
        ) { _ in
            self.incrementStreak()
        }
    }
    
    func loadData() {
        // Load from UserDefaults or CoreData
        if let data = UserDefaults.standard.data(forKey: "reactionProfile"),
           let decoded = try? JSONDecoder().decode(ReactionProfile.self, from: data) {
            self.profile = decoded
            self.bestReactionTime = decoded.bestReactionTime
        }
        
        if let streak = UserDefaults.standard.object(forKey: "currentStreak") as? Int {
            self.currentStreak = streak
        }
    }
    
    func updateBestTime(_ time: TimeInterval) {
        if time < bestReactionTime {
            bestReactionTime = time
            profile.bestReactionTime = time
            saveProfile()
        }
    }
    
    func incrementStreak() {
        currentStreak += 1
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
    }
    
    private func saveProfile() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: "reactionProfile")
        }
    }
}

