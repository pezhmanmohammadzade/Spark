import Foundation
import SwiftData
import SwiftUI

public final class GamificationService: Sendable {
    @MainActor public static let shared = GamificationService()
    
    private init() {}
    
    @MainActor
    public func awardXP(_ amount: Int, to stats: UserStats, modelContext: ModelContext?) {
        let oldLevel = stats.level
        stats.addXP(amount)
        
        let newLevel = stats.level
        if newLevel > oldLevel {
            // Level Up logic if needed specifically outside of stats update
            HapticManager.shared.triggerSuccess()
        } else {
            HapticManager.shared.triggerImpact(1)
        }
        
        try? modelContext?.save()
    }
    
    @MainActor
    public func validateStreak(for stats: UserStats, modelContext: ModelContext?) {
        let calendar = Calendar.current
        let today = Date()
        
        // Simple logic for checking if we should reset or increment streak
        if let last = stats.lastActivityDate {
            if calendar.isDateInToday(last) {
                // Already active today
                return
            } else if calendar.isDateInYesterday(last) {
                stats.dailyStreak += 1
            } else {
                // Streak broken
                stats.dailyStreak = 1
            }
        } else {
            stats.dailyStreak = 1
        }
        
        stats.lastActivityDate = today
        try? modelContext?.save()
    }
}
