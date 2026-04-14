import Foundation
import SwiftData

@MainActor
public final class AIService: Sendable {
    public static let shared = AIService()
    
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
    
    private let groqAPIEndpoint = "https://api.groq.com/openai/v1/chat/completions"
    
    // Internal generic method for making calls to Groq API
    private func fetchGroqCompletion(prompt: String, systemPrompt: String = "You are SPARK, an elite AI coach specialized in Challenge-Based Learning (CBL) and product strategy. You are highly analytical, somewhat provocative, and focus on demanding intellectual depth. Be concise.") async throws -> String {
        // Safety check for consent
        guard AIConsentManager.shared.hasGrantedConsent else {
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: groqAPIEndpoint) else {
            throw URLError(.badURL)
        }
        
        let messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": prompt]
        ]
        
        let requestBody: [String: Any] = [
            "model": "llama-3.3-70b-versatile",
            "messages": messages,
            "temperature": 0.7
        ]
        
        guard let payload = try? JSONSerialization.data(withJSONObject: requestBody) else {
            throw URLError(.cannotParseResponse)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(Secrets.groqAPIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("API Error: \(String(data: data, encoding: .utf8) ?? "Unknown")")
            throw URLError(.badServerResponse)
        }
        
        struct GroqResponse: Codable {
            struct Choice: Codable {
                struct Message: Codable {
                    let content: String
                }
                let message: Message
            }
            let choices: [Choice]
        }
        
        let decodedResponse = try JSONDecoder().decode(GroqResponse.self, from: data)
        guard let firstChoice = decodedResponse.choices.first else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return firstChoice.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// AI Architect that turns a raw idea into a structured CBL Mission
    public func structureMission(rawInput: String) async -> (title: String, idea: String, mission: String) {
        let systemPrompt = "You are SPARK. A user gives you a raw fragment of an idea. Extract a catchy 2-4 word Title, rewrite the raw idea as a refined 'SPARK' insight, and write a concise 1-2 sentence Mission Strategy."
        let prompt = "Extract this format exactly:\nTITLE: [The Title]\nSPARK: [The Spark Insight]\nMISSION: [The Strategy]\n\nIdea: \(rawInput)"
        
        do {
            let response = try await fetchGroqCompletion(prompt: prompt, systemPrompt: systemPrompt)
            let lines = response.components(separatedBy: "\n")
            
            var title = "New Evolution"
            var sparkIdea = "THE SPARK: \"\(rawInput)\"\n\nA raw conceptual fragment identified."
            var missionDesc = "MISSION STRATEGY: Initialize phase-gated evolution."
            
            for line in lines {
                if line.hasPrefix("TITLE:") { title = line.replacingOccurrences(of: "TITLE:", with: "").trimmingCharacters(in: .whitespaces) }
                if line.hasPrefix("SPARK:") { sparkIdea = line.replacingOccurrences(of: "SPARK:", with: "").trimmingCharacters(in: .whitespaces) }
                if line.hasPrefix("MISSION:") { missionDesc = line.replacingOccurrences(of: "MISSION:", with: "").trimmingCharacters(in: .whitespaces) }
            }
            
            return (title, sparkIdea, missionDesc)
        } catch {
            return ("New Evolution", rawInput, "MISSION STRATEGY: Initialize phase-gated evolution. Spark detects potential in the problem space.")
        }
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
        let systemPrompt = "You evaluate startup/learning steps. The user gives content for phase: \(type). Evaluate the depth. Return EXACTLY this format:\nSCORE: [0.0 to 1.0]\nINSIGHT: [1 sentence analysis]\nCHALLENGE: [1 provocative sentence]\nQ1: [Guiding question 1]\nQ2: [Guiding question 2]"
        let prompt = "Evaluate this content: \"\(content)\""
        
        var feedback = StepFeedback()
        var score: Double = 0.5
        
        do {
            let response = try await fetchGroqCompletion(prompt: prompt, systemPrompt: systemPrompt)
            let lines = response.components(separatedBy: "\n")
            
            var qs: [String] = []
            
            for line in lines {
                if line.hasPrefix("SCORE:") {
                    let numStr = line.replacingOccurrences(of: "SCORE:", with: "").trimmingCharacters(in: .whitespaces)
                    score = Double(numStr) ?? 0.5
                }
                if line.hasPrefix("INSIGHT:") { feedback.insight = line.replacingOccurrences(of: "INSIGHT:", with: "").trimmingCharacters(in: .whitespaces) }
                if line.hasPrefix("CHALLENGE:") { feedback.challenge = line.replacingOccurrences(of: "CHALLENGE:", with: "").trimmingCharacters(in: .whitespaces) }
                if line.hasPrefix("Q1:") { qs.append(line.replacingOccurrences(of: "Q1:", with: "").trimmingCharacters(in: .whitespaces)) }
                if line.hasPrefix("Q2:") { qs.append(line.replacingOccurrences(of: "Q2:", with: "").trimmingCharacters(in: .whitespaces)) }
            }
            
            feedback.guidingQuestions = qs
            if score < 0.6 {
                feedback.suggestion = "EXPAND YOUR DESCRIPTION TO ADDRESS THE CORE FRICTION POINT."
            }
            
            return (score, feedback)
        } catch {
            return (0.5, StepFeedback(insight: "NETWORK ERROR. CONTINUING WITH LOCAL HEURISTICS.", challenge: "ARE YOU RELYING TOO HEAVILY ON EXTERNAL COMPUTATION?", guidingQuestions: ["HOW DOES THIS SYSTEM OPERATE OFFLINE?"], suggestion: "RE-EVALUATE LATER."))
        }
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
        let wordCount = response.split(separator: " ").count
        if wordCount < minWords {
             return (false, "INCIDENCE DETECTED: RESPONSE IS TOO SHALLOW. THE METABOLIC DEPTH IS INSUFFICIENT FOR \(topic.uppercased()) EVOLUTION. EXPLAIN DEEPER.")
        }
        
        let systemPrompt = "You are SPARK, evaluating a user's answer to a strategic workshop challenge named '\(title)' in the topic of '\(topic)'. The answer must display high-level strategic reasoning. Analyze the answer. Output EXACTLY this format:\nVALID: [TRUE or FALSE]\nFEEDBACK: [1-2 sentences of brutal, honest assessment]"
        let prompt = "User Response:\n\(response)"
        
        do {
            let apiRes = try await fetchGroqCompletion(prompt: prompt, systemPrompt: systemPrompt)
            let lines = apiRes.components(separatedBy: "\n")
            var isValid = true
            var feedbackMsg = "EVOLUTION VALIDATED: STRATEGY ACCEPTED."
            
            for line in lines {
                if line.hasPrefix("VALID:") {
                    isValid = line.uppercased().contains("TRUE")
                }
                if line.hasPrefix("FEEDBACK:") {
                    feedbackMsg = line.replacingOccurrences(of: "FEEDBACK:", with: "").trimmingCharacters(in: .whitespaces)
                }
            }
            
            return (isValid, feedbackMsg.uppercased())
        } catch {
            // Fallback to naive keyword match if network fails
            let matches = keywords.filter { response.lowercased().contains($0.lowercased()) }
            let matchRate = Double(matches.count) / Double(max(keywords.count, 1))
            if matchRate < 0.3 {
                return (false, "NETWORK ERROR FALLBACK: YOU HAVE MENTIONED NONE OF THE CORE GUIDING PRINCIPLES (\(keywords.prefix(2).joined(separator: ", "))). NARRATIVE RE-EVOLUTION IS REQUIRED.")
            }
            return (true, "NETWORK ERROR FALLBACK: EVOLUTION VALIDATED. OFFLINE HEURISTICS ACCEPT YOUR ARCHITECTURE.")
        }
    }

    /// Generic Chat interface for CoachView
    public func coachChat(_ message: String) async -> String {
        do {
            return try await fetchGroqCompletion(prompt: message)
        } catch {
            return "CONNECTION SEVERED. RE-ESTABLISHING NEURAL LINK SHORTLY."
        }
    }
}
