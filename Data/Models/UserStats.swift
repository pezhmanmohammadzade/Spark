import Foundation
import SwiftData

@Model
public class UserStats: Identifiable {
    public var id: UUID = UUID()
    public var currentXP: Int = 0
    public var level: Int = 1
    public var dailyStreak: Int = 0
    public var lastActivityDate: Date?
    
    public var levelTitle: String {
        switch level {
        case 1...5: return "Novice Explorer"
        case 6...12: return "Spark Architect"
        default: return "Spark Master"
        }
    }
    
    public var xpForNextLevel: Int {
        level * 1000
    }
    
    public init() {}
    
    public func addXP(_ amount: Int) {
        currentXP += amount
        checkAndUpdateStreak()
        
        if currentXP >= xpForNextLevel {
            currentXP -= xpForNextLevel
            level += 1
        }
    }
    
    public func checkAndUpdateStreak() {
        let now = Date()
        guard let last = lastActivityDate else {
            dailyStreak = 1
            lastActivityDate = now
            return
        }
        
        let calendar = Calendar.current
        if calendar.isDateInYesterday(last) {
            dailyStreak += 1
            lastActivityDate = now
        } else if calendar.isDateInToday(last) {
            // Already active today, do nothing
        } else {
            // Missed a day (or more), reset
            dailyStreak = 1
            lastActivityDate = now
        }
    }
}
