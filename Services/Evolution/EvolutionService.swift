import Foundation
import SwiftData

public final class EvolutionService: Sendable {
    @MainActor public static let shared = EvolutionService()
    
    private init() {}
    
    @MainActor
    public func completeStep(_ step: CBLStep, in project: CBLProject, stats: UserStats, modelContext: ModelContext?) {
        guard !step.isCompleted else { return }
        
        step.isCompleted = true
        GamificationService.shared.awardXP(step.xpValue, to: stats, modelContext: modelContext)
        
        // Custom logic for phase completion can be triggered here.
        evaluateProjectPhaseProgress(project: project)
        
        try? modelContext?.save()
    }
    
    @MainActor
    private func evaluateProjectPhaseProgress(project: CBLProject) {
        // Here we could trigger a "Milestone Achieved" event 
        // if an entire phase's steps are completed.
        // For now, we'll let the Views read `completionForPhase`
    }
}
