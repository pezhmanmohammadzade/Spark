import Foundation
import SwiftData
import SwiftUI

public final class GamificationService: Sendable {
    @MainActor public static let shared = GamificationService()
    
    private init() {}
    
    // MARK: - Trophy Milestone Definitions
    
    private struct TrophyDef {
        let name: String
        let description: String
        let icon: String
        let type: String   // "orb", "prism", "crystal"
        let hue: Double
        let milestone: String
    }
    
    private let levelTrophies: [Int: TrophyDef] = [
        5: TrophyDef(
            name: "Ignition Core",
            description: "The first spark of potential crystallized into form.",
            icon: "flame.fill", type: "orb", hue: 0.6, milestone: "level_5"
        ),
        10: TrophyDef(
            name: "Neural Forge",
            description: "Your neural pathways have been permanently enhanced.",
            icon: "brain.head.profile", type: "prism", hue: 0.75, milestone: "level_10"
        ),
        15: TrophyDef(
            name: "Spark Catalyst",
            description: "You accelerate evolution in everything you touch.",
            icon: "bolt.trianglebadge.exclamationmark.fill", type: "crystal", hue: 0.08, milestone: "level_15"
        ),
        20: TrophyDef(
            name: "Void Breaker",
            description: "The void trembles. You have transcended conventional limits.",
            icon: "star.fill", type: "orb", hue: 0.12, milestone: "level_20"
        )
    ]
    
    // MARK: - Quality-Based XP Award (Suggestion #1)
    
    /// Awards XP scaled by AI evaluation score and streak multiplier.
    /// Returns the XP awarded and whether it was a "Critical Hit".
    @MainActor
    public func awardQualityXP(
        baseXP: Int,
        score: Double,
        to stats: UserStats,
        modelContext: ModelContext?
    ) -> (xpAwarded: Int, isCriticalHit: Bool) {
        let clampedScore = max(score, 0.3) // Minimum 30% of base XP
        var effectiveXP = Int(Double(baseXP) * clampedScore * stats.streakMultiplier)
        
        let isCriticalHit = score >= 0.85
        if isCriticalHit {
            effectiveXP += baseXP / 2 // 50% bonus on Critical Hit
        }
        
        let oldLevel = stats.level
        stats.addXP(effectiveXP)
        let newLevel = stats.level
        
        if newLevel > oldLevel {
            HapticManager.shared.triggerSuccess()
            checkAndGrantShields(to: stats)
            checkAndMintTrophies(for: stats, modelContext: modelContext)
        } else if isCriticalHit {
            HapticManager.shared.triggerSuccess()
        } else {
            HapticManager.shared.triggerImpact(1)
        }
        
        try? modelContext?.save()
        return (effectiveXP, isCriticalHit)
    }
    
    /// Awards flat XP for non-scored actions (workshops, etc.)
    @MainActor
    public func awardXP(_ amount: Int, to stats: UserStats, modelContext: ModelContext?) {
        let oldLevel = stats.level
        stats.addXP(amount)
        
        let newLevel = stats.level
        if newLevel > oldLevel {
            HapticManager.shared.triggerSuccess()
            checkAndGrantShields(to: stats)
            checkAndMintTrophies(for: stats, modelContext: modelContext)
        } else {
            HapticManager.shared.triggerImpact(1)
        }
        
        try? modelContext?.save()
    }
    
    // MARK: - Unified Streak Validation (Suggestion #6)
    
    /// Single source of truth for streak management.
    /// Absorbs logic formerly in UserStats.checkAndUpdateStreak().
    /// Consumes a Neural Shield if a day is missed and shields are available.
    @MainActor
    public func validateStreak(for stats: UserStats, modelContext: ModelContext?) {
        let calendar = Calendar.current
        let today = Date()
        
        if let last = stats.lastActivityDate {
            if calendar.isDateInToday(last) {
                // Already active today
                return
            } else if calendar.isDateInYesterday(last) {
                stats.dailyStreak += 1
            } else {
                // Missed day(s) — attempt Neural Shield protection
                if stats.neuralShields > 0 {
                    stats.neuralShields -= 1
                    stats.shieldsUsed += 1
                    // Streak preserved! Don't reset.
                } else {
                    // Streak broken
                    stats.dailyStreak = 1
                }
            }
        } else {
            stats.dailyStreak = 1
        }
        
        stats.lastActivityDate = today
        try? modelContext?.save()
    }
    
    // MARK: - Neural Shield Grants (Suggestion #3)
    
    /// Grants 1 Neural Shield every 10 levels.
    @MainActor
    private func checkAndGrantShields(to stats: UserStats) {
        // Calculate expected shields for current level
        let expectedShields = stats.level / 10
        let totalEverGranted = stats.neuralShields + stats.shieldsUsed
        
        if expectedShields > totalEverGranted {
            let newShields = expectedShields - totalEverGranted
            stats.neuralShields += newShields
        }
    }
    
    // MARK: - Trophy Minting (Suggestion #2)
    
    /// Checks for level-based milestones and mints trophies that haven't been created yet.
    @MainActor
    private func checkAndMintTrophies(for stats: UserStats, modelContext: ModelContext?) {
        guard let modelContext = modelContext else { return }
        
        // Check level-based trophies
        for (requiredLevel, def) in levelTrophies {
            if stats.level >= requiredLevel {
                mintTrophyIfNeeded(def: def, modelContext: modelContext)
            }
        }
    }
    
    /// Checks for project/workshop milestones and mints trophies.
    /// Call this after completing a project or all workshops.
    @MainActor
    public func checkMilestoneTrophies(
        completedProjects: Int,
        allWorkshopsCompleted: Bool,
        modelContext: ModelContext?
    ) {
        guard let modelContext = modelContext else { return }
        
        if completedProjects >= 1 {
            let def = TrophyDef(
                name: "First Spark",
                description: "Your first evolution cycle is complete. The journey has begun.",
                icon: "sparkles", type: "crystal", hue: 0.55, milestone: "first_project"
            )
            mintTrophyIfNeeded(def: def, modelContext: modelContext)
        }
        
        if allWorkshopsCompleted {
            let def = TrophyDef(
                name: "Nexus Master",
                description: "Every workshop conquered. You are the strategic menace.",
                icon: "seal.fill", type: "prism", hue: 0.55, milestone: "all_workshops"
            )
            mintTrophyIfNeeded(def: def, modelContext: modelContext)
        }
    }
    
    @MainActor
    private func mintTrophyIfNeeded(def: TrophyDef, modelContext: ModelContext) {
        // Check if trophy already exists
        let milestone = def.milestone
        let descriptor = FetchDescriptor<Trophy>(
            predicate: #Predicate { $0.milestone == milestone }
        )
        
        let existing = (try? modelContext.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }
        
        let trophy = Trophy(
            name: def.name,
            description: def.description,
            icon: def.icon,
            type: def.type,
            hue: def.hue,
            milestone: def.milestone
        )
        modelContext.insert(trophy)
        try? modelContext.save()
    }
}
