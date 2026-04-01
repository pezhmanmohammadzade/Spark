import Foundation
import SwiftData

@Model
final class UserStats {
    var id: UUID = UUID()
    var currentXP: Int = 0
    var level: Int = 1
    var dailyStreak: Int = 0
    var lastActiveDate: Date?
    var totalStepsCompleted: Int = 0
    
    init() {
        self.id = UUID()
        self.currentXP = 0
        self.level = 1
        self.dailyStreak = 0
        self.totalStepsCompleted = 0
    }
    
    // Logic to calculate level based on XP (Standard RPG curve)
    var xpForNextLevel: Int {
        level * 1000 
    }
    
    func addXP(_ amount: Int) {
        currentXP += amount
        if currentXP >= xpForNextLevel {
            currentXP -= xpForNextLevel
            level += 1
            // This would trigger a "Level Up" event in the UI
        }
    }
}
