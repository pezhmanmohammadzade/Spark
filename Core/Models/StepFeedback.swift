import Foundation

struct StepFeedback: Codable {
    var insight: String = ""
    var challenge: String = ""
    var guidingQuestions: [String] = []
    var suggestion: String?
    
    static var placeholder: StepFeedback {
        StepFeedback(
            insight: "Analyze your input for strategic alignment.",
            challenge: "Identify any vague or abstract concepts.",
            guidingQuestions: ["How does this solve a real-world problem?", "Who is the specific target audience?"],
            suggestion: "Draft a more concrete problem statement."
        )
    }
}
