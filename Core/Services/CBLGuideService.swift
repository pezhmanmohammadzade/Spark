import Foundation

public struct GuideContent {
    public let title: String
    public let definition: String
    public let strategicGoal: String
    public let successCriteria: [String]
    public let pitfall: String
    public let icon: String
}

public final class CBLGuideService {
    @MainActor public static let shared = CBLGuideService()
    
    private init() {}
    
    public func guide(for type: String) -> GuideContent {
        switch type.lowercased() {
        case "big idea":
            return GuideContent(
                title: "THE BIG IDEA",
                definition: "A broad, global concept that has personal and community relevance.",
                strategicGoal: "Anchor your evolution in a problem space that is large enough to sustain long-term growth.",
                successCriteria: [
                    "Is it a universal human theme (e.g., Sustainability)?",
                    "Does it provoke multiple perspectives?",
                    "Is it interesting to a broad audience?"
                ],
                pitfall: "DON'T solve yet. If your Big Idea is 'A better coffee mug', you've already skipped the discovery phase.",
                icon: "sparkles"
            )
            
        case "essential question":
            return GuideContent(
                title: "ESSENTIAL QUESTION",
                definition: "A question that narrows the Big Idea down to a specific contextual inquiry.",
                strategicGoal: "Filter out the noise and focus your Spark on a single, powerful investigative direction.",
                successCriteria: [
                    "Does it require deep research to answer?",
                    "Is it open-ended with no single correct answer?",
                    "Does it connect the Big Idea to your local reality?"
                ],
                pitfall: "Avoid 'Yes/No' questions. An Essential Question should ignite a debate, not a simple confirmation.",
                icon: "questionmark.circle.fill"
            )
            
        case "challenge":
            return GuideContent(
                title: "THE CHALLENGE",
                definition: "A call to action that transforms the Essential Question into a specific, measurable objective.",
                strategicGoal: "Create a tactical target for your evolution. This is the 'What' that you will actually build.",
                successCriteria: [
                    "Is it actionable?",
                    "Is it measurable?",
                    "Does it directly address the Essential Question?"
                ],
                pitfall: "The Challenge is often mistaken for the solution. 'Build a website' is a solution. 'Connect local farmers to urban kitchens' is a Challenge.",
                icon: "target"
            )
            
        case "guiding questions":
            return GuideContent(
                title: "GUIDING QUESTIONS",
                definition: "The specific sub-questions you need to answer to meet the Challenge.",
                strategicGoal: "Deconstruct your mission into manageable data points. Identify the gaps in your current knowledge.",
                successCriteria: [
                    "Do they cover all aspects of the Challenge?",
                    "Are they targeted at finding specific data?",
                    "Do they prioritize the most critical unknowns?"
                ],
                pitfall: "Don't ask questions you already know the answer to. Use this phase to find the 'Unexpected Truths'.",
                icon: "magnifyingglass"
            )
            
        case "guiding activities":
            return GuideContent(
                title: "GUIDING ACTIVITIES",
                definition: "The research methods and actions used to answer your Guiding Questions.",
                strategicGoal: "Move from safe theory to messy reality. Validate your assumptions with raw data.",
                successCriteria: [
                    "Are the activities direct (e.g., Interviews, Prototypes)?",
                    "Do they provide evidence-based answers?",
                    "Are they time-efficient?"
                ],
                pitfall: "Spending too much time reading and not enough time 'doing'. Get out of the building.",
                icon: "hammer.fill"
            )
            
        case "guiding resources":
            return GuideContent(
                title: "GUIDING RESOURCES",
                definition: "The tools, experts, and data sources required for your activities.",
                strategicGoal: "Equip your mission with the high-fidelity intelligence needed to make resilient decisions.",
                successCriteria: [
                    "Are the resources credible?",
                    "Do they represent diverse viewpoints?",
                    "Are they accessible?"
                ],
                pitfall: "Relying on a single source of truth. Spark requires a multi-faceted data architecture.",
                icon: "books.vertical.fill"
            )
            
        case "synthesis":
            return GuideContent(
                title: "RESEARCH SYNTHESIS",
                definition: "Connecting the dots between your activities to find the core solution direction.",
                strategicGoal: "Transform raw data into tactical insight. This is the 'Aha' moment of the Investigation phase.",
                successCriteria: [
                    "Have you identified a core pattern or paradox?",
                    "Is the insight supported by your research data?",
                    "Does it lead directly to a solution concept?"
                ],
                pitfall: "Ignoring data that contradicts your initial idea. A true Spark pivot happens here.",
                icon: "brain.head.profile"
            )
            
        case "solution concept":
            return GuideContent(
                title: "SOLUTION CONCEPT",
                definition: "The initial architecture of how you intend to meet the Challenge.",
                strategicGoal: "Define the 'Minimum Viable Magic' of your evolution. What is the core value loop?",
                successCriteria: [
                    "Does it solve the primary friction identified?",
                    "Is it unique compared to incumbents?",
                    "Is it feasible with current resources?"
                ],
                pitfall: "Over-engineering. Focus on the one feature that makes the rest of the problem irrelevant.",
                icon: "lightbulb.fill"
            )
            
        case "implementation":
            return GuideContent(
                title: "TACTICAL IMPLEMENTATION",
                definition: "The act of prototype delivery and user testing.",
                strategicGoal: "Stress-test your solution in the real world. Measure the metabolic response of your users.",
                successCriteria: [
                    "Was it tested with real target users?",
                    "Are you collecting qualitative and quantitative data?",
                    "Is the feedback loop fast?"
                ],
                pitfall: "Waiting for 'Perfect'. A rough prototype today is better than a perfect vision next month.",
                icon: "bolt.fill"
            )
            
        case "reflection":
            return GuideContent(
                title: "EVOLUTION REFLECTION",
                definition: "Evaluating the impact of your solution and the journey taken.",
                strategicGoal: "Solidify the learning into your long-term neural path. Prepare for the next recursive loop.",
                successCriteria: [
                    "What surprised you the most?",
                    "What would you do differently next time?",
                    "How has the Big Idea evolved?"
                ],
                pitfall: "Treating 'Failure' as the end. Reflection is the Spark that ignites the *next* mission.",
                icon: "waveform.path.ecg"
            )
            
        default:
            return GuideContent(
                title: "SPARK GUIDANCE",
                definition: "A mission step designed to accelerate your evolution.",
                strategicGoal: "Apply tactical depth to this phase of your project.",
                successCriteria: [
                    "Is the input honest?",
                    "Is it detailed?",
                    "Does it push the mission forward?"
                ],
                pitfall: "Surface-level participation leads to surface-level results.",
                icon: "brain"
            )
        }
    }
}
