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
    
    // NEW Pedagogical Fields
    public var guidingCoreSteps: [String] = []
    public var learningOutcome: String = ""
    public var aiValidationKeywords: [String] = []
    public var minimumWordCount: Int = 20
    
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
        minWords: Int = 20
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
    }
    
    public static var seedWorkshops: [Workshop] {
        let now = Date()
        
        return [
            // STRATEGY
            Workshop(
                title: "MARKET DISRUPTION 101", 
                topic: "Strategy", 
                description: "Identify cognitive friction in existing markets and learn to disrupt with Spark's tactical positioning.", 
                scheduledDate: now.addingTimeInterval(3600 * 1),
                icon: "bolt.shield.fill",
                guidingCore: ["Differentiation > Betterment.", "Find incumbent complacency.", "Create a positioning wedge."],
                outcome: "Master market entry via cognitive friction.",
                keywords: ["gap", "incumbent", "friction", "positioning", "wedge"],
                minWords: 20
            ),
            Workshop(
                title: "THE MOAT STRATEGY", 
                topic: "Strategy", 
                description: "Building defensible competitive advantages that resist market erosion.", 
                scheduledDate: now.addingTimeInterval(3600 * 2),
                icon: "castle.fill",
                guidingCore: ["Network effects.", "Switching costs.", "Proprietary data moats."],
                outcome: "Build a defensible ecosystem architecture.",
                keywords: ["moat", "network", "switching", "ecosystem", "defensive"],
                minWords: 20
            ),
            Workshop(
                title: "BLUE OCEAN ARCHITECTURE", 
                topic: "Strategy", 
                description: "Creating new market space and making the competition irrelevant.", 
                scheduledDate: now.addingTimeInterval(3600 * 4),
                icon: "water.waves",
                guidingCore: ["Elimination/Reduction/Raising/Creation.", "Value innovation.", "Non-customer segments."],
                outcome: "Execute a blue ocean tactical shift.",
                keywords: ["ocean", "innovation", "irrelevant", "value", "segment"],
                minWords: 25
            ),
            Workshop(
                title: "SURVIVAL PIVOT", 
                topic: "Strategy", 
                description: "When and how to change direction without losing the core Spark.", 
                scheduledDate: now.addingTimeInterval(3600 * 6),
                icon: "arrow.triangle.2.circlepath",
                guidingCore: ["Hypothesis testing.", "Sunk cost fallacy.", "Core competency preservation."],
                outcome: "Master the mechanics of a tactical pivot.",
                keywords: ["pivot", "hypothesis", "iteration", "resource", "signal"],
                minWords: 20
            ),
            
            // GROWTH
            Workshop(
                title: "VIRAL ARCHITECTURE", 
                topic: "Growth", 
                description: "Engineering organic expansion loops directly into the product core.", 
                scheduledDate: now.addingTimeInterval(3600 * 8),
                icon: "chart.line.uptrend.xyaxis",
                guidingCore: ["Viral coefficient.", "Cycle time.", "Incentive design."],
                outcome: "Engineer self-sustaining growth loops.",
                keywords: ["loop", "referral", "viral", "organic", "velocity"],
                minWords: 30
            ),
            Workshop(
                title: "RETENTION LOOPS", 
                topic: "Growth", 
                description: "The mechanics of user habit formation and anti-churn architecture.", 
                scheduledDate: now.addingTimeInterval(3600 * 10),
                icon: "arrow.clockwise.circle.fill",
                guidingCore: ["Hook model.", "Variable rewards.", "Investment and triggers."],
                outcome: "Mitigate silent churn via recursive engagement.",
                keywords: ["retention", "hook", "churn", "trigger", "habit"],
                minWords: 25
            ),
            Workshop(
                title: "NETWORK EFFECT ENGINEERING", 
                topic: "Growth", 
                description: "Scaling value as user density increases.", 
                scheduledDate: now.addingTimeInterval(3600 * 12),
                icon: "network",
                guidingCore: ["Critical mass.", "Data network effects.", "Platform dynamics."],
                outcome: "Leverage density for exponential value.",
                keywords: ["network", "mass", "density", "platform", "value"],
                minWords: 30
            ),
            Workshop(
                title: "AGGREGATION THEORY", 
                topic: "Growth", 
                description: "Controlling the user relationship to dominate the value chain.", 
                scheduledDate: now.addingTimeInterval(3600 * 14),
                icon: "square.grid.3x3.fill",
                guidingCore: ["Supplier modularization.", "Exclusive user interfaces.", "Zero marginal costs."],
                outcome: "Analyze the power of demand-side scale.",
                keywords: ["aggregation", "demand", "supply", "interface", "marginal"],
                minWords: 25
            ),
            
            // FINANCE
            Workshop(
                title: "UNIT ECONOMICS VITALITY", 
                topic: "Finance", 
                description: "The metabolic math: LTV, CAC, and path to sustainability.", 
                scheduledDate: now.addingTimeInterval(3600 * 16),
                icon: "dollarsign.circle.fill",
                guidingCore: ["LTV/CAC > 3.", "Payback months.", "Contribution margin."],
                outcome: "Analyze business model sustainability.",
                keywords: ["ltv", "cac", "payback", "margin", "economics"],
                minWords: 20
            ),
            Workshop(
                title: "FUNDRAISING NARRATIVE", 
                topic: "Finance", 
                description: "Translating tactical success into investor-ready vision.", 
                scheduledDate: now.addingTimeInterval(3600 * 18),
                icon: "paperclip.circle.fill",
                guidingCore: ["Total Addressable Market.", "Venture scale logic.", "Story of inevitable growth."],
                outcome: "Architect a compelling fundraising engine.",
                keywords: ["narrative", "tam", "venture", "milestone", "investment"],
                minWords: 30
            ),
            Workshop(
                title: "BURN RATE MITIGATION", 
                topic: "Finance", 
                description: "Optimizing runway without sacrificing evolution speed.", 
                scheduledDate: now.addingTimeInterval(3600 * 20),
                icon: "flame.fill",
                guidingCore: ["Fixed vs Variable costs.", "Efficiency ratios.", "Default alive vs Default dead."],
                outcome: "Manage financial runway tactically.",
                keywords: ["burn", "runway", "efficiency", "variable", "survival"],
                minWords: 20
            ),
            Workshop(
                title: "REVENUE MECHANICS", 
                topic: "Finance", 
                description: "Pricing as a product feature. Recurring vs Transactional loops.", 
                scheduledDate: now.addingTimeInterval(3600 * 22),
                icon: "banknote.fill",
                guidingCore: ["Price sensitivity.", "SaaS metrics.", "Expansion revenue."],
                outcome: "Engineer a high-performance pricing loop.",
                keywords: ["revenue", "pricing", "saas", "recurring", "monetization"],
                minWords: 25
            ),
            
            // PSYCHOLOGY
            Workshop(
                title: "COGNITIVE STICKINESS", 
                topic: "Psychology", 
                description: "Designing for neural reward systems and inevitable habits.", 
                scheduledDate: now.addingTimeInterval(3600 * 24),
                icon: "brain.head.profile",
                guidingCore: ["Neural triggers.", "Variable rewards.", "Dopamine loops."],
                outcome: "Design products that users crave.",
                keywords: ["dopamine", "neural", "trigger", "stickiness", "habit"],
                minWords: 30
            ),
            Workshop(
                title: "BEHAVIORAL FRICTION", 
                topic: "Psychology", 
                description: "Using friction to filter users and reduce cognitive load.", 
                scheduledDate: now.addingTimeInterval(3600 * 26),
                icon: "hand.raised.fill",
                guidingCore: ["Opt-in vs Opt-out.", "Paradox of choice.", "Friction as a filter."],
                outcome: "Master the use of strategic friction.",
                keywords: ["friction", "choice", "cognitive", "load", "filter"],
                minWords: 25
            ),
            Workshop(
                title: "INCENTIVE DESIGN", 
                topic: "Psychology", 
                description: "Aligning user actions with system goals via game theory.", 
                scheduledDate: now.addingTimeInterval(3600 * 28),
                icon: "target",
                guidingCore: ["Intrinsic vs Extrinsic.", "Gamification mechanics.", "Reward schedules."],
                outcome: "Architect high-integrity incentive loops.",
                keywords: ["incentive", "gamification", "reward", "extrinsic", "intrinsic"],
                minWords: 30
            ),
            Workshop(
                title: "CHOICE ARCHITECTURE", 
                topic: "Psychology", 
                description: "Influencing decisions without restricting options.", 
                scheduledDate: now.addingTimeInterval(3600 * 30),
                icon: "arrow.branch",
                guidingCore: ["Nudge theory.", "Default options.", "Information hierarchy."],
                outcome: "Master the art of the 'Nudge'.",
                keywords: ["nudge", "default", "hierarchy", "decision", "architecture"],
                minWords: 20
            ),
            
            // PRODUCT & LEADERSHIP
            Workshop(
                title: "ZERO-TO-ONE LIFECYCLE", 
                topic: "Product", 
                description: "The path from raw idea to Product-Market Fit.", 
                scheduledDate: now.addingTimeInterval(3600 * 32),
                icon: "01.circle.fill",
                guidingCore: ["Idea validation.", "The 10x rule.", "Minimum Viable Product."],
                outcome: "Master the zero-to-one evolution.",
                keywords: ["pmf", "validation", "iteration", "10x", "product"],
                minWords: 30
            ),
            Workshop(
                title: "MINIMUM VIABLE MAGIC", 
                topic: "Product", 
                description: "Identifying the core feature that feels like magic.", 
                scheduledDate: now.addingTimeInterval(3600 * 34),
                icon: "wand.and.rays",
                guidingCore: ["The 'Aha' moment.", "Core value proposition.", "Removing the fluff."],
                outcome: "Define and ship the 'Magic' feature.",
                keywords: ["magic", "aha", "core", "mvp", "simplicity"],
                minWords: 20
            ),
            Workshop(
                title: "FOUNDER RESILIENCE", 
                topic: "Leadership", 
                description: "Managing the psychology of the founder journey.", 
                scheduledDate: now.addingTimeInterval(3600 * 36),
                icon: "shield.checkered",
                guidingCore: ["Emotional regulation.", "Decision fatigue.", "The internal narrative."],
                outcome: "Fortify the founder psychology.",
                keywords: ["resilience", "fatigue", "regulation", "psychology", "mental"],
                minWords: 25
            ),
            Workshop(
                title: "CULTURE AS CODE", 
                topic: "Leadership", 
                description: "Encoding company values into repeatable systems.", 
                scheduledDate: now.addingTimeInterval(3600 * 38),
                icon: "chevron.left.forwardslash.chevron.right",
                guidingCore: ["Hiring for alignment.", "Operating principles.", "Feedback loops."],
                outcome: "Architect a high-performance culture.",
                keywords: ["culture", "hiring", "principles", "values", "systems"],
                minWords: 30
            ),
            
            // MARKETING
            Workshop(
                title: "RECURSIVE STORYTELLING", 
                topic: "Marketing", 
                description: "Narratives that repeat themselves in the user's mind.", 
                scheduledDate: now.addingTimeInterval(3600 * 40),
                icon: "book.closed.fill",
                guidingCore: ["Hero's journey (User as Hero).", "Nexus as Guide.", "Brand archetypes."],
                outcome: "Master self-replicating brand narratives.",
                keywords: ["story", "hero", "narrative", "recursive", "brand"],
                minWords: 25
            ),
            Workshop(
                title: "COMMUNITY MOATS", 
                topic: "Marketing", 
                description: "Building defensible networks of engaged advocates.", 
                scheduledDate: now.addingTimeInterval(3600 * 42),
                icon: "person.3.fill",
                guidingCore: ["Identity loops.", "UGC engineering.", "The sense of belonging."],
                outcome: "Architect a loyal community ecosystem.",
                keywords: ["community", "advocate", "identity", "ugc", "engaged"],
                minWords: 30
            )
        ]
    }
}
