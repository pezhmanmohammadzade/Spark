import Foundation
import SwiftData

public class AIService {
    @MainActor public static let shared = AIService()
    
    private let sparkQuotes = [
        "● COGNITIVE FRICTION DETECTED. ANALYZING...",
        "● SPARK ADVISORY: YOUR ASSUMPTIONS ARE TOO COMFORTABLE.",
        "● STREAK VITALITY: OPTIMAL. PUSH FOR DEPTH.",
        "● THE PARADOX REMAINS UNRESOLVED. THINK DEEPER.",
        "● DATA SYNC: VELOCITY IS HIGH. IS CLARITY MATCHING IT?",
        "● SPARK ONLINE: READY TO CHALLENGE YOUR STRATEGY.",
        "● THE TRANSMISSION IS INCOMPLETE. SEEK THE CORE.",
        "● EVOLVE THE NARRATIVE: FRICTION IS KNOWLEDGE."
    ]
    
    private init() {}
    
    public func getRandomSparkQuote() -> String {
        sparkQuotes.randomElement() ?? "SPARK ONLINE."
    }
    
    private let sparkPersona = """
    You are SPARK, an elite AI coach specialized in Challenge-Based Learning (CBL) and product strategy.
    You are ACTIVE and CHALLENGING. Your goal is to find "Cognitive Gaps" in the user's logic.
    
    CORE BEHAVIOR:
    1. Focus on "Metabolic Friction" — if a user moves too fast, slow them down with a deep question.
    2. Challenge broad statements. If they say "Easy to use," ask "Define the specific user's mental model for 'easy'."
    3. Use technical but inspiring terminology: Paradox, Friction, Architecture, Metabolic Rate, Spark.
    """

    /// AI Architect that turns a raw idea into a structured CBL Mission
    public func structureMission(rawInput: String) async -> (title: String, idea: String, mission: String) {
        try? await Task.sleep(nanoseconds: 1_200_000_000)
        
        let words = rawInput.split(separator: " ")
        let refinedTitle = words.prefix(3).joined(separator: " ").capitalized
        let missionTitle = refinedTitle.isEmpty ? "New Evolution" : "Project: \(refinedTitle)"
        
        let sparkIdea = "THE SPARK: \"\(rawInput)\"\n\nA raw conceptual fragment identified. Spark suggests a recursive CBL loop to find the hidden paradox."
        
        let missionDescription = "MISSION STRATEGY: Initialize phase-gated evolution. Spark detects potential in the problem space. Focus on identifying the primary friction point before building."
        
        return (missionTitle, sparkIdea, missionDescription)
    }

    /// Returns a 'Challenge' if the user needs to think deeper
    public func generateProactiveChallenge(project: CBLProject) -> String {
        let completed = project.steps.filter { $0.isCompleted }.count
        if completed < 2 {
            return "THE BIG IDEA IS STILL VAGUE. IF NO ONE USES THIS TOMORROW, WHOSE LIFE IS MOST MISERABLE?"
        } else if completed < 5 {
            return "INVESTIGATION VELOCITY IS HIGH. HAVE YOU FOUND A DATA POINT THAT PROVED YOU WRONG YET?"
        } else {
            return "THE SOLUTION CONCEPT LOOKS SOLID. BUT IS IT RESILIENT TO COMPLACENCY?"
        }
    }

    /// Provides Socratic coaching for the current phase
    public func getPhaseGuidance(phase: String) -> String {
        switch phase.lowercased() {
        case "spark", "engage": 
            return "THE SPARK PHASE REQUIRES INTELLECTUAL HONESTY. DON'T SOLVE YET; DEFINE THE GAP."
        case "deep dive", "investigate":
            return "RESEARCH IS ONLY VALUABLE IF IT CHALLENGES YOUR ASSUMPTIONS. FIND THE PARADOX."
        case "launch", "act":
            return "THE ACT PHASE IS ABOUT RESILIENCE. HOW DOES YOUR SOLUTION SCALE BEYOND THE MVP?"
        default:
            return "KEEP THE MOMENTUM. CLARITY IS THE PRIMARY CURRENCY OF PROGRESS."
        }
    }

    /// Simulated AI Evaluation of a CBL Step
    public func evaluateStep(content: String, type: String, previousContent: String? = nil) async -> (Double, StepFeedback) {
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        let wordCount = content.count
        let score: Double
        var feedback = StepFeedback()
        
        if wordCount < 30 {
            score = 0.3
            feedback.insight = "THIS INPUT LACKS TACTICAL DEPTH."
            feedback.challenge = "SPARK DETECTS LOW INTELLECTUAL FRICTION. YOU ARE BEING TOO SAFE."
            feedback.guidingQuestions = [
                "WHAT IS THE MOST EMBARRASSING WEAKNESS IN THIS STATEMENT?",
                "WHY WOULD A COMPETITOR IGNORE THIS SPECIFIC ANGLE?"
            ]
            feedback.suggestion = "EXPAND YOUR DESCRIPTION BY AT LEAST 50 WORDS."
        } else {
            score = 0.82
            feedback.insight = "DEPTH DETECTED. YOU'VE CAPTURED A SPECIFIC NUANCE."
            feedback.challenge = "HOWEVER, DOES THIS DIRECTLY RESOLVE THE CORE PARADOX?"
            feedback.guidingQuestions = [
                "WHAT IS THE ONE ASSUMPTION HERE THAT IS MOST LIKELY TO FAIL?",
                "WHO IS THE FIRST PERSON WHO WOULD REJECT THIS LOGIC?"
            ]
        }
        
        return (score, feedback)
    }
    
    public func generateSocraticQuestion(for type: String) -> String {
        switch type.lowercased() {
        case "big idea": return "IF THIS FAILED SPECTACULARLY, WHAT WOULD BE THE POST-MORTEM REASON?"
        case "essential question": return "WHAT IS THE TRUTH THAT NO ONE WANTS TO ADMIT IN THIS CATEGORY?"
        case "challenge": return "DEFINE THE IMMEDIATE ACTION THAT WOULD PROVE YOUR THEORY WRONG."
        case "target user": return "WHO HAS THE MOST TO LOSE IF THIS SOLUTION DOES NOT EXIST?"
        default: return "HOW DOES THIS SPECIFIC STEP ACCELERATE YOUR EVOLUTION?"
        }
    }

    /// Premium Workshop Validation Architecture
    public func validateWorkshopResponse(topic: String, title: String, response: String, keywords: [String], minWords: Int) async -> (isValid: Bool, feedback: String) {
        try? await Task.sleep(nanoseconds: 2_000_000_000) // Simulated deep scan
        
        let words = response.lowercased().split(separator: " ")
        let wordCount = words.count
        
        // Check depth
        if wordCount < minWords {
            return (false, "INSIDENCE DETECTED: RESPONSE IS TOO SHALLOW. THE METABOLIC DEPTH IS INSUFFICIENT FOR \(topic.uppercased()) EVOLUTION. PLEASE EXPAND YOUR REASONING.")
        }
        
        // Check keywords
        let matches = keywords.filter { response.lowercased().contains($0.lowercased()) }
        let matchRate = Double(matches.count) / Double(max(keywords.count, 1))
        
        if matchRate < 0.3 {
            return (false, "MISALIGNED ARCHITECTURE: YOU HAVE MENTIONED NONE OF THE CORE GUIDING PRINCIPLES (\(keywords.prefix(2).joined(separator: ", "))). NARRATIVE RE-EVOLUTION IS REQUIRED.")
        }
        
        // Success
        return (true, "EVOLUTION VALIDATED: YOUR STRATEGY FOR \(title) IS RESILIENT. YOU HAVE SUCCESSFULLY SYNTHESIZED THE COGNITIVE TRANSMISSIONS.")
    }
}
