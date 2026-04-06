import Foundation
import SwiftData

@Model
public class Workshop: Identifiable {
    public var id: UUID = UUID()
    public var title: String = ""
    public var topic: String = ""
    public var instructorAI: String = "NEXUS"
    public var workshopDescription: String = ""
    public var scheduledDate: Date = Date()
    public var durationMinutes: Int = 30
    public var xpValue: Int = 500
    public var isCompleted: Bool = false
    public var topicIcon: String = "sparkles"
    
    // NEW Pedagogical Fields (V2)
    public var guidingCoreSteps: [String] = []
    public var learningOutcome: String = ""
    public var aiValidationKeywords: [String] = []
    public var minimumWordCount: Int = 20
    public var masteryBadge: String = "" // e.g. "STRATEGIC_SURVIVOR"
    
    public init(
        title: String, 
        topic: String, 
        description: String, 
        scheduledDate: Date, 
        duration: Int = 30, 
        icon: String = "sparkles",
        guidingCore: [String] = [],
        outcome: String = "",
        keywords: [String] = [],
        minWords: Int = 20,
        badge: String = ""
    ) {
        self.title = title
        self.topic = topic
        self.workshopDescription = description
        self.scheduledDate = scheduledDate
        self.durationMinutes = duration
        self.topicIcon = icon
        self.guidingCoreSteps = guidingCore
        self.learningOutcome = outcome
        self.aiValidationKeywords = keywords
        self.minimumWordCount = minWords
        self.masteryBadge = badge
    }
    
}