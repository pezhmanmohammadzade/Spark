import Foundation
import SwiftData


@Model
final class CBLProject {
    var id: UUID = UUID()
    var title: String = ""
    var projectDescription: String = ""
    var createdAt: Date = Date()
    @Relationship(deleteRule: .cascade) var steps: [CBLStep] = []
    @Relationship(deleteRule: .cascade) var snapshots: [EvolutionSnapshot] = []
    
    init(title: String, description: String = "") {
        self.id = UUID()
        self.title = title
        self.projectDescription = description
        self.createdAt = Date()
        self.steps = CBLStep.createDefaultSteps()
    }
}

@Model
final class CBLStep {
    var id: UUID = UUID()
    var type: String = "" // e.g. "bigIdea", "essentialQuestion"
    var content: String = ""
    
    // Structured Feedback
    var aiInsight: String = ""
    var aiChallenge: String = ""
    var aiGuidingQuestions: [String] = []
    var aiSuggestion: String = ""
    
    var evaluationScore: Double = 0.0 // 0.0 to 1.0 (70% required to pass)
    var isCompleted: Bool = false
    var order: Int = 0
    var xpValue: Int = 50 // Default XP reward
    
    init(type: String, order: Int, xpValue: Int = 50) {
        self.id = UUID()
        self.type = type
        self.order = order
        self.xpValue = xpValue
    }
    
    static func createDefaultSteps() -> [CBLStep] {
        let definition: [(String, Int)] = [
            ("Big Idea", 50), ("Essential Question", 50), ("Challenge", 100), 
            ("Guiding Questions", 75), ("Guiding Activities", 75), ("Guiding Resources", 50), 
            ("Synthesis", 150), ("Solution Concept", 200), ("Implementation", 150), ("Reflection", 100)
        ]
        return definition.enumerated().map { index, def in
            CBLStep(type: def.0, order: index, xpValue: def.1)
        }
    }
}

@Model
final class EvolutionSnapshot {
    var id: UUID = UUID()
    var timestamp: Date = Date()
    var stepType: String = ""
    var previousContent: String = ""
    var newContent: String = ""
    var reason: String = ""
    
    init(stepType: String, previous: String, new: String, reason: String = "") {
        self.timestamp = Date()
        self.stepType = stepType
        self.previousContent = previous
        self.newContent = new
        self.reason = reason
    }
}
