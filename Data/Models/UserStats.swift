import Foundation
import SwiftData

@Model
public class UserStats: Identifiable {
    public var id: UUID = UUID()
    public var currentXP: Int = 0
    public var level: Int = 1
    public var dailyStreak: Int = 0
    public var lastActivityDate: Date?
    
    // MARK: - Neural Shields (Streak Freeze Protection)
    /// Earned every 10 levels. Prevents streak reset when a day is missed.
    public var neuralShields: Int = 0
    /// Tracks total shields consumed over the user's lifetime.
    public var shieldsUsed: Int = 0
    
    // MARK: - Computed Properties
    
    public var levelTitle: String {
        switch level {
        case 1...5: return "Novice Explorer"
        case 6...12: return "Spark Architect"
        case 13...20: return "Neural Architect"
        default: return "Spark Overlord"
        }
    }
    
    public var xpForNextLevel: Int {
        level * 1000
    }
    
    /// Streak-based XP multiplier. Rewards consistency.
    public var streakMultiplier: Double {
        switch dailyStreak {
        case 0...2: return 1.0
        case 3...6: return 1.1
        case 7...13: return 1.25
        case 14...29: return 1.5
        default: return 2.0
        }
    }
    
    public init() {}
    
    /// Adds raw XP and handles level-up progression.
    /// NOTE: Streak validation is handled exclusively by GamificationService.
    public func addXP(_ amount: Int) {
        currentXP += amount
        
        if currentXP >= xpForNextLevel {
            currentXP -= xpForNextLevel
            level += 1
        }
    }
}
