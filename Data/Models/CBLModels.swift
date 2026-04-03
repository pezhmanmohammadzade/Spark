import Foundation
import SwiftData

@Model
public class CBLProject: Identifiable {
    public var id: UUID = UUID()
    public var title: String = ""
    public var initialIdea: String = ""
    public var projectDescription: String = ""
    public var createdAt: Date = Date()
    
    @Relationship(deleteRule: .cascade)
    public var steps: [CBLStep] = []
    
    public init(title: String = "", initialIdea: String = "", description: String = "") {
        self.title = title
        self.initialIdea = initialIdea
        self.projectDescription = description
    }
    
    public func completionForPhase(types: [String]) -> Double {
        let phaseSteps = steps.filter { types.contains($0.type) }
        guard !phaseSteps.isEmpty else { return 0 }
        let completed = phaseSteps.filter { $0.isCompleted }.count
        return Double(completed) / Double(phaseSteps.count)
    }
    
    public func generateDefaultSteps() {
        let engages = ["Big Idea", "Essential Question", "Challenge"]
        let investigates = ["Guiding Questions", "Guiding Activities", "Guiding Resources", "Synthesis"]
        let acts = ["Solution Concept", "Implementation", "Reflection"]
        
        var allSteps: [CBLStep] = []
        var order = 0
        
        for type in engages {
            allSteps.append(CBLStep(title: type, type: type, order: order))
            order += 1
        }
        for type in investigates {
            allSteps.append(CBLStep(title: type, type: type, order: order))
            order += 1
        }
        for type in acts {
            allSteps.append(CBLStep(title: type, type: type, order: order))
            order += 1
        }
        
        // Link steps to project
        self.steps = allSteps
    }
}

@Model
public class CBLStep: Identifiable {
    public var id: UUID = UUID()
    public var title: String = ""
    public var type: String = "" // Big Idea, Essential Question, etc.
    public var content: String = ""
    public var aiInsight: String = ""
    public var aiChallenge: String = ""
    public var aiGuidingQuestions: [String] = []
    public var aiSuggestion: String = ""
    public var evaluationScore: Double = 0.0
    public var isCompleted: Bool = false
    public var order: Int = 0
    
    public var xpValue: Int {
        switch type {
        case "Big Idea", "Essential Question", "Challenge": return 50
        case "Solution Concept", "Implementation", "Reflection": return 150
        default: return 100
        }
    }
    
    public init(title: String, type: String, order: Int) {
        self.title = title
        self.type = type
        self.order = order
    }
}
