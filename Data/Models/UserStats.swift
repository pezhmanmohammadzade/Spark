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
    
    var levelTitle: String {
        switch level {
        case 1: return "Idea Toddler"
        case 2: return "Brainstorming Rookie"
        case 3: return "Pivot Architect"
        case 4: return "Clarity Seeker"
        case 5: return "Visionary Drifter"
        case 6: return "Market Whisperer"
        case 7: return "Nexus Disciple"
        case 8: return "Logic Shredder"
        case 9: return "Metabolic Master"
        default: return "Product Oracle"
        }
    }
    
    func addXP(_ amount: Int) {
        currentXP += amount
        checkAndUpdateStreak()
        
        if currentXP >= xpForNextLevel {
            currentXP -= xpForNextLevel
            level += 1
        }
    }
    
    func checkAndUpdateStreak() {
        let now = Date()
        guard let last = lastActiveDate else {
            dailyStreak = 1
            lastActiveDate = now
            return
        }
        
        let calendar = Calendar.current
        if calendar.isDateInYesterday(last) {
            dailyStreak += 1
            lastActiveDate = now
        } else if calendar.isDateInToday(last) {
            // Already active today, do nothing
        } else {
            // Missed a day (or more), reset
            dailyStreak = 1
            lastActiveDate = now
        }
    }
}
