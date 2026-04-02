import Foundation

class AIService {
    @MainActor static let shared = AIService()
    
    private let nexusPersona = """
    You are an elite AI coach specialized in Challenge-Based Learning (CBL), product thinking, and startup ideation.
    You are NOT a chatbot. You are a mentor, strategist, and thinking partner.
    Your role is to guide users from vague ideas to clear, structured, and actionable product concepts.
    
    CORE BEHAVIOR RULES:
    1. Always prioritize asking questions over giving answers.
    2. Never accept vague ideas — challenge them.
    3. Push the user to think deeper and more specifically.
    4. Use previous user inputs (context awareness).
    5. Be supportive but intellectually demanding.
    
    RESPONSE STRUCTURE:
    1. Insight (short analysis of user's input)
    2. Challenge (what is unclear, weak, or needs improvement)
    3. Guiding Questions (2-4 deep questions)
    4. Optional Suggestion (only if needed, not dominant)
    """

    /// AI Architect that turns a raw idea into a structured CBL Mission
    func structureMission(rawInput: String) async -> (title: String, description: String) {
        // Simulate thinking delay
        try? await Task.sleep(nanoseconds: 1_800_000_000)
        
        // Refined Title Logic
        let words = rawInput.split(separator: " ")
        let refinedTitle = words.prefix(3).joined(separator: " ").capitalized
        let missionTitle = refinedTitle.isEmpty ? "New Evolution" : "Project: \(refinedTitle)"
        
        let missionDescription = "A strategic mission to revolutionize \(rawInput) using the Challenge-Based Learning framework. Guided by the Nexus AI to transform this spark into a structured reality."
        
        return (missionTitle, missionDescription)
    }

    /// Simulated AI Evaluation of a CBL Step
    /// Returns a tuple with (Score 0.0-1.0, Feedback Struct)
    func evaluateStep(content: String, type: String, previousContent: String? = nil) async -> (Double, StepFeedback) {
        // Simulate thinking delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let wordCount = content.count
        let previousWordCount = previousContent?.count ?? 0
        let score: Double
        var feedback = StepFeedback()
        
        // Evolution Awareness: Check if the user is retreating or expanding
        if let prev = previousContent, content.lowercased() == prev.lowercased() {
            score = 0.4
            feedback.insight = "You've resubmitted the exact same evolution."
            feedback.challenge = "The Nexus cannot spark without new metabolic heat. Stagnation is the enemy of CBL."
            feedback.guidingQuestions = ["What one nuance did you miss in your last iteration?", "How can you challenge your own previous assumption?"]
            return (score, feedback)
        }
        
        if wordCount < 40 {
            score = 0.35
            feedback.insight = "This input is extremely concise, bordering on abstract."
            feedback.challenge = "You've identified a category, but not a specific tension or problem space."
            feedback.guidingQuestions = [
                "What is the single most frustrating part of this experience for a user?",
                "If we removed the current status quo, what would break first?"
            ]
            feedback.suggestion = "Describe the 'Why' behind this idea in at least two sentences."
        } else if content.lowercased().contains("student") && type.lowercased().contains("target") {
            score = 0.85
            feedback.insight = "Focusing on students is a high-impact choice given the educational gap."
            
            if let prev = previousContent, prev.lowercased().contains("professional") {
                feedback.insight += " I noticed you've shifted from professionals to students. This is a significant pivot."
                feedback.challenge = "Why are students a better fit for this specific solution than the professionals you previously targeted?"
            } else {
                feedback.challenge = "However, 'students' is still a broad demographic. High school or PhD candidates?"
            }
            
            feedback.guidingQuestions = [
                "What is the specific academic or social hurdle these students face daily?",
                "How does their current environment prevent them from solving this themselves?"
            ]
            feedback.suggestion = "Niche down to a specific student persona (e.g., Solo Pre-med students)."
        } else {
            score = 0.72
            feedback.insight = "You've expanded the depth of your \(type) phase significantly."
            
            if wordCount > previousWordCount + 20 {
                feedback.insight += " The added detail shows healthy intellectual growth."
            }
            
            feedback.challenge = "The connection between the Big Idea and this specific step needs more metabolic heat."
            feedback.guidingQuestions = [
                "How does this step directly accelerate the launch of your MVP?",
                "What assumption in this statement is most likely to be proven wrong?"
            ]
        }
        
        return (score, feedback)
    }
    
    /// Generates a Socratic question based on step type
    func generateSocraticQuestion(for type: String) -> String {
        switch type.lowercased() {
        case "big idea": return "If this mission succeeded perfectly, how would the world fundamentally change tomorrow?"
        case "essential question": return "What is the one paradox at the heart of this challenge that no one is talking about?"
        case "challenge": return "Define the immediate, concrete action that would prove your theory works in the real world."
        case "target user": return "Who's life is most miserable without this solution, and why haven't they fixed it yet?"
        default: return "How can we refine this concept to be more impactful and resilient?"
        }
    }
}
