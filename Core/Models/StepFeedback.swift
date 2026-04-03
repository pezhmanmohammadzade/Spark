import Foundation

public struct StepFeedback: Codable {
    public var insight: String = ""
    public var challenge: String = ""
    public var guidingQuestions: [String] = []
    public var suggestion: String?
    
    public init(insight: String = "", challenge: String = "", guidingQuestions: [String] = [], suggestion: String? = nil) {
        self.insight = insight
        self.challenge = challenge
        self.guidingQuestions = guidingQuestions
        self.suggestion = suggestion
    }
    
    public static var placeholder: StepFeedback {
        StepFeedback(
            insight: "Analyze your input for strategic alignment.",
            challenge: "Identify any vague or abstract concepts.",
            guidingQuestions: ["How does this solve a real-world problem?", "Who is the specific target audience?"],
            suggestion: "Draft a more concrete problem statement."
        )
    }
}
