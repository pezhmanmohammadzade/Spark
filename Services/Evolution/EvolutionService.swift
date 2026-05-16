import Foundation
import SwiftData

public final class EvolutionService: Sendable {
    @MainActor public static let shared = EvolutionService()
    
    private init() {}
    
    /// Completes a step with quality-based XP, using the AI evaluation score.
    @MainActor
    public func completeStep(
        _ step: CBLStep,
        in project: CBLProject,
        score: Double,
        stats: UserStats,
        modelContext: ModelContext?
    ) -> (xpAwarded: Int, isCriticalHit: Bool) {
        guard !step.isCompleted else { return (0, false) }
        
        step.isCompleted = true
        
        // Award quality-scaled XP based on AI evaluation score
        let result = GamificationService.shared.awardQualityXP(
            baseXP: step.xpValue,
            score: score,
            to: stats,
            modelContext: modelContext
        )
        
        evaluateProjectPhaseProgress(project: project, modelContext: modelContext)
        
        try? modelContext?.save()
        return result
    }
    
    /// Legacy flat-XP completion for non-evaluated steps.
    @MainActor
    public func completeStep(_ step: CBLStep, in project: CBLProject, stats: UserStats, modelContext: ModelContext?) {
        guard !step.isCompleted else { return }
        
        step.isCompleted = true
        GamificationService.shared.awardXP(step.xpValue, to: stats, modelContext: modelContext)
        
        evaluateProjectPhaseProgress(project: project, modelContext: modelContext)
        
        try? modelContext?.save()
    }
    
    @MainActor
    private func evaluateProjectPhaseProgress(project: CBLProject, modelContext: ModelContext?) {
        // Check if entire project is completed → mint "First Spark" trophy
        let allCompleted = !project.steps.isEmpty && project.steps.allSatisfy { $0.isCompleted }
        if allCompleted {
            GamificationService.shared.checkMilestoneTrophies(
                completedProjects: 1,
                allWorkshopsCompleted: false,
                modelContext: modelContext
            )
        }
    }
}
