import Foundation

class AIService {
    @MainActor static let shared = AIService()
    
    /// Simulated AI Architect that turns a raw idea into a CBL Mission Title/Description
    func structureMission(rawInput: String) async -> (title: String, description: String) {
        // Simulate thinking delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Primitive logic for structure
        let refinedTitle = "Project: " + (rawInput.split(separator: " ").prefix(3).joined(separator: " ").capitalized)
        let refinedDescription = "A mission to revolutionize \(rawInput) through the challenge-based learning framework. Goal: Creating a professional prototype by the Launch phase."
        
        return (refinedTitle, refinedDescription)
    }
    
    /// Simulated AI Evaluation of a CBL Step
    /// Returns a tuple with (Score 0.0-1.0, Feedback String)
    func evaluateStep(content: String, type: String) async -> (Double, String) {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        let wordCount = content.split(separator: " ").count
        var score: Double = 0.0
        var feedback: String = ""
        
        // Primitive logic for demo: length = depth
        if wordCount < 5 {
            score = Double.random(in: 0.1...0.3)
            feedback = "The Nexus requires more depth. Your vision is too surface-level to spark a true revolution. Elaborate on the 'Why'."
        } else if wordCount < 15 {
            score = Double.random(in: 0.4...0.65)
            feedback = "Good foundation, but the Socratic spirit demands precision. How does this specific idea challenge the status quo?"
        } else {
            score = Double.random(in: 0.75...0.98)
            feedback = "Exceptional clarity. You've identified a core resonance in the \(type) phase. The logic is sound and the vision is compelling."
        }
        
        return (score, feedback)
    }
    
    /// Generates a Socratic question based on step type
    func generateSocraticQuestion(for type: String) -> String {
        switch type.lowercased() {
        case "bigidea": return "If this mission succeeded perfectly, how would the world fundamentally change tomorrow?"
        case "essentialquestion": return "What is the one paradox at the heart of this challenge that no one is talking about?"
        case "challenge": return "Define the immediate, concrete action that would prove your theory works in the real world."
        default: return "How can we refine this concept to be more impactful and resilient?"
        }
    }
}
