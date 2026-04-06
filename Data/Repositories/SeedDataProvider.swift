import Foundation
import SwiftData

@MainActor
public struct SeedDataProvider {
    public static let shared = SeedDataProvider()
    private init() {}
    
        public static var seedWorkshops: [Workshop] {
        let now = Date()
        
        return [
            // --- STRATEGY PILLAR ---
            Workshop(
                title: "MARKET DISRUPTION 101", 
                topic: "Strategy", 
                description: "Identify cognitive friction in existing markets and learn to disrupt with Spark's tactical positioning.", 
                scheduledDate: now.addingTimeInterval(3600 * 1),
                icon: "bolt.shield.fill",
                guidingCore: [
                    "TEACHING: Disruption is not about doing the same thing better. It's about doing something different that makes the old way irrelevant. You aren't fighting the incumbent; you're changing the game they are playing.",
                    "TEACHING: To disrupt, you must find 'Incumbent Complacency'. These are the inefficiencies that established players consider 'unavoidable' but customers find 'unbearable'.",
                    "TACTIC: Identify the 'Core Friction' in your segment. Map out every step a user takes and find where they sigh. That sigh is your entry point.",
                    "CORE: Create a positioning wedge. Focus on a single, underserved friction point and own it completely. Once you're in, you can expand.",
                ],
                outcome: "Master market entry via cognitive friction analysis.",
                keywords: ["gap", "incumbent", "friction", "positioning", "wedge"],
                minWords: 30,
                badge: "DISRUPTION_INITIATE"
            ),
            Workshop(
                title: "THE MOAT STRATEGY", 
                topic: "Strategy", 
                description: "Building defensible competitive advantages that resist market erosion.", 
                scheduledDate: now.addingTimeInterval(3600 * 2),
                icon: "castle.fill",
                guidingCore: [
                    "TEACHING: A Moat is a structural barrier that protects your profit margins from competitors. Without a moat, competition will eventually drive your profits to zero.",
                    "TEACHING: Moats come in four primary flavors: Network Effects, Switching Costs, Cost Advantages, and Intangible Assets (Brand/Patents).",
                    "TACTIC: Audit your product: If a competitor offered the same thing for free tomorrow, why would users stay? If you can't answer, you don't have a moat.",
                    "CORE: The strongest moats are built into the product architecture, not the marketing budget. Build high switching costs through user investment.",
                ],
                outcome: "Build a defensible ecosystem architecture.",
                keywords: ["moat", "network", "switching", "ecosystem", "defensive"],
                minWords: 30,
                badge: "MOAT_ARCHITECT"
            ),
            Workshop(
                title: "BLUE OCEAN ARCHITECTURE", 
                topic: "Strategy", 
                description: "Creating new market space and making the competition irrelevant.", 
                scheduledDate: now.addingTimeInterval(3600 * 4),
                icon: "water.waves",
                guidingCore: [
                    "TEACHING: Blue Ocean strategy is the simultaneous pursuit of differentiation and low cost to open up a new market space. It's about 'Value Innovation'.",
                    "TEACHING: Use the ERRC Grid: Eliminate factors the industry takes for granted. Reduce factors below standard. Raise factors above standard. Create factors never offered.",
                    "TACTIC: Look at 'Non-Customers'. Why do they avoid your industry? Solving their barrier is often the key to a Blue Ocean.",
                    "CORE: Stop competing. Start creating. If you are looking at your competitors to decide your features, you've already lost.",
                ],
                outcome: "Execute a blue ocean tactical shift.",
                keywords: ["ocean", "innovation", "irrelevant", "value", "segment"],
                minWords: 35,
                badge: "OCEAN_EXPLORER"
            ),
            Workshop(
                title: "RECURSIVE POSITIONING", 
                topic: "Strategy", 
                description: "How to position your product so it's the only logical choice.", 
                scheduledDate: now.addingTimeInterval(3600 * 5),
                icon: "target",
                guidingCore: [
                    "TEACHING: Positioning is the act of designing your offering so that it occupies a distinct and valued place in the target customer's mind.",
                    "TACTIC: Define your 'Category' then blow it up. Don't be a 'Better Email'; be a 'Asynchronous Decision Engine'.",
                    "CORE: If you aren't the #1 in your category, create a new sub-category where you are.",
                ],
                outcome: "Nailing the unique value proposition.",
                keywords: ["positioning", "category", "mindshare", "logic", "unique"],
                minWords: 25,
                badge: "STRATEGIC_LOGICIAN"
            ),
            
            // --- GROWTH PILLAR ---
            Workshop(
                title: "VIRAL ARCHITECTURE", 
                topic: "Growth", 
                description: "Engineering organic expansion loops directly into the product core.", 
                scheduledDate: now.addingTimeInterval(3600 * 8),
                icon: "chart.line.uptrend.xyaxis",
                guidingCore: [
                    "TEACHING: Viral growth is not a marketing campaign; it's a product feature. If the core use-case doesn't naturally involve another person, it's not a loop.",
                    "TEACHING: The Viral Coefficient (K) must be greater than 1. K = (number of invites per user) x (conversion rate of those invites).",
                    "TACTIC: Focus on 'Cycle Time'. How fast does a new user invite the next? Shorter cycle times win markets exponentially.",
                    "CORE: Growth is a byproduct of value. If users don't find value immediately, they won't invite others. Solve retention before virality.",
                ],
                outcome: "Engineer self-sustaining growth loops.",
                keywords: ["loop", "referral", "viral", "organic", "velocity"],
                minWords: 40,
                badge: "GROWTH_ENGINEER"
            ),
            Workshop(
                title: "RETENTION LOOPS", 
                topic: "Growth", 
                description: "The mechanics of user habit formation and anti-churn architecture.", 
                scheduledDate: now.addingTimeInterval(3600 * 10),
                icon: "arrow.clockwise.circle.fill",
                guidingCore: [
                    "TEACHING: Retention is the foundation of all growth. It is 5x cheaper to keep a user than to find a new one. A growth loop without retention is a leaky bucket.",
                    "TEACHING: Use the Hook Model: Trigger -> Action -> Variable Reward -> Investment. The goal is to move from external triggers to internal ones.",
                    "TACTIC: Identify your 'Aha' moment. This is the exact second a user realizes the value of your product. Maximize the speed to 'Aha'.",
                    "CORE: Churn is a silent killer. Monitor 'Day 1' and 'Day 7' retention with religious fanaticism.",
                ],
                outcome: "Mitigate silent churn via recursive engagement.",
                keywords: ["retention", "hook", "churn", "trigger", "habit"],
                minWords: 35,
                badge: "RETENTION_MASTER"
            ),
            Workshop(
                title: "NETWORK EFFECT ENGINEERING", 
                topic: "Growth", 
                description: "Scaling value as user density increases.", 
                scheduledDate: now.addingTimeInterval(3600 * 12),
                icon: "network",
                guidingCore: [
                    "TEACHING: Network effects occur when a product becomes more valuable to existing users as new users join. This creates a powerful 'Winner-Take-All' dynamic.",
                    "TACTIC: Move from 'Utility' value to 'Network' value. Utility is what I do alone; Network is what we do together. The latter is defensible.",
                    "CORE: Critical Mass is the tipping point where the network's value outweighs the cost of switching for a new user.",
                ],
                outcome: "Leverage density for exponential value.",
                keywords: ["network", "mass", "density", "platform", "value"],
                minWords: 30,
                badge: "NETWORK_TACTICIAN"
            ),
            Workshop(
                title: "ACQUISITION CHANNELS", 
                topic: "Growth", 
                description: "Finding the one high-velocity path to your user.", 
                scheduledDate: now.addingTimeInterval(3600 * 13),
                icon: "megaphone.fill",
                guidingCore: [
                    "TEACHING: 90% of your growth will come from 1 channel. Most startups fail because they try to do 5 channels at once.",
                    "TACTIC: Test and kill. Spend $100 and 1 week on a channel. If it doesn't show a spark, move on.",
                    "CORE: Your channel must match your price point. You can't use sales for a $10 app; you can't use ads for a $1M software.",
                ],
                outcome: "Channel-Model fit mastery.",
                keywords: ["acquisition", "channel", "ads", "seo", "sales"],
                minWords: 25,
                badge: "CHANNEL_COMMANDER"
            ),
            
            // --- FINANCE PILLAR ---
            Workshop(
                title: "UNIT ECONOMICS VITALITY", 
                topic: "Finance", 
                description: "The metabolic math: LTV, CAC, and path to sustainability.", 
                scheduledDate: now.addingTimeInterval(3600 * 16),
                icon: "dollarsign.circle.fill",
                guidingCore: [
                    "TEACHING: Your business has a heartbeat: the LTV to CAC ratio. Lifetime Value must be at least 3x the Cost of Acquisition for a healthy business.",
                    "TEACHING: Payback Period is the number of months it takes to earn back the CAC. For startups, this should be under 12 months.",
                    "TACTIC: Don't ignore the 'Fully Loaded CAC'. Include marketing salaries, tool costs, and failed experiments in your math.",
                    "CORE: Unit economics don't lie. Scaling a business with bad unit economics is just a faster way to bankruptcy.",
                ],
                outcome: "Analyze business model sustainability.",
                keywords: ["ltv", "cac", "payback", "margin", "economics"],
                minWords: 30,
                badge: "ECONOMY_ANALYST"
            ),
            Workshop(
                title: "FUNDRAISING NARRATIVE", 
                topic: "Finance", 
                description: "Translating tactical success into investor-ready vision.", 
                scheduledDate: now.addingTimeInterval(3600 * 18),
                icon: "paperclip.circle.fill",
                guidingCore: [
                    "TEACHING: Investors are not buying your product; they are buying a share of a future, much larger company. You are selling a 'Return on Investment'.",
                    "TACTIC: Tell the story of 'Inevitable Growth'. Show why your success is a mathematical certainty if capital is applied.",
                    "CORE: Fundraising is a momentum game. You want to create 'Fear of Missing Out' (FOMO) by moving fast between meetings.",
                ],
                outcome: "Architect a compelling fundraising engine.",
                keywords: ["narrative", "tam", "venture", "milestone", "investment"],
                minWords: 35,
                badge: "VENTURE_VISIONARY"
            ),
            Workshop(
                title: "REVENUE MECHANICS", 
                topic: "Finance", 
                description: "Pricing as a product feature. Recurring vs Transactional loops.", 
                scheduledDate: now.addingTimeInterval(3600 * 22),
                icon: "banknote.fill",
                guidingCore: [
                    "TEACHING: Pricing is the most powerful lever for profit. A 1% price increase can lead to an 11% profit increase. Most people underprice.",
                    "TACTIC: Use 'Value-Based Pricing', not 'Cost-Plus'. Charge based on the problem you solve, not the hours it took to build.",
                    "CORE: Recurring revenue creates a 'valuation multiple'. Invest in SaaS loops for long-term wealth.",
                ],
                outcome: "Engineer a high-performance pricing loop.",
                keywords: ["revenue", "pricing", "saas", "recurring", "monetization"],
                minWords: 30,
                badge: "REVENUE_ARCHITECT"
            ),
            
            // --- PSYCHOLOGY PILLAR ---
            Workshop(
                title: "COGNITIVE STICKINESS", 
                topic: "Psychology", 
                description: "Designing for neural reward systems and inevitable habits.", 
                scheduledDate: now.addingTimeInterval(3600 * 24),
                icon: "brain.head.profile",
                guidingCore: [
                    "TEACHING: Habit formation is the result of repeated neural firing in response to a specific trigger. You want your product to be the 'Internal Response'.",
                    "TEACHING: Use 'Variable Rewards' (The Slot Machine effect). If a user knows exactly what they will find, they get bored. If it's a surprise, they get a dopamine spike.",
                    "TACTIC: Increase 'Investment'. The more data, time, or social capital a user puts in, the higher their 'Loss Aversion' becomes.",
                    "CORE: Ethical habit design wins. Build tools that improve users' lives so they feel good about their 'addiction'.",
                ],
                outcome: "Design products that users crave.",
                keywords: ["dopamine", "neural", "trigger", "stickiness", "habit"],
                minWords: 40,
                badge: "NEURAL_DESIGNER"
            ),
            Workshop(
                title: "BEHAVIORAL FRICTION", 
                topic: "Psychology", 
                description: "Using friction to filter users and reduce cognitive load.", 
                scheduledDate: now.addingTimeInterval(3600 * 26),
                icon: "hand.raised.fill",
                guidingCore: [
                    "TEACHING: Not all friction is bad. High-quality users often need to 'earn' their way into a community to value it. This is the 'IKEA Effect'.",
                    "TACTIC: Reduce 'Cognitive Load'. Every choice is a cost. Use sensible defaults to guide the user towards success without thinking.",
                    "CORE: Match the 'Motivation' to the 'Ability'. If a task is hard, the motivation must be massive. If motivation is low, the task must be trivial.",
                ],
                outcome: "Master the use of strategic friction.",
                keywords: ["friction", "choice", "cognitive", "load", "filter"],
                minWords: 30,
                badge: "FRICTION_SPECIALIST"
            ),
            
            // --- PRODUCT PILLAR ---
            Workshop(
                title: "ZERO-TO-ONE LIFECYCLE", 
                topic: "Product", 
                description: "The path from raw idea to Product-Market Fit.", 
                scheduledDate: now.addingTimeInterval(3600 * 32),
                icon: "01.circle.fill",
                guidingCore: [
                    "TEACHING: Product-Market Fit (PMF) is when your value proposition meets a desperate market need. You'll know you have it when the market is pulling the product out of you.",
                    "TACTIC: Apply the '10x Rule'. Your solution must be 10x better than the status quo to overcome the inertia of established habits.",
                    "CORE: Iterate faster than your peers. The team that learns the most about the customer in 30 days wins the industry.",
                ],
                outcome: "Master the zero-to-one evolution.",
                keywords: ["pmf", "validation", "10x", "product", "iteration"],
                minWords: 35,
                badge: "PMF_HUNTER"
            ),
            Workshop(
                title: "MINIMUM VIABLE MAGIC", 
                topic: "Product", 
                description: "Identifying the core feature that feels like magic.", 
                scheduledDate: now.addingTimeInterval(3600 * 34),
                icon: "wand.and.rays",
                guidingCore: [
                    "TEACHING: An MVP should not be 'minimum' features; it should be 'minimal magic'. One feature that works perfectly is better than ten that are mediocre.",
                    "TACTIC: Kill every feature that doesn't feed your 'North Star Metric'. If it's extra code, it's just extra weight.",
                    "CORE: Complexity is the enemy of adoption. Solve one problem so well that people can't believe it didn't exist before.",
                ],
                outcome: "Define and ship the 'Magic' feature.",
                keywords: ["magic", "aha", "core", "mvp", "simplicity"],
                minWords: 30,
                badge: "MAGIC_ARCHITECT"
            ),
            
            // --- LEADERSHIP PILLAR ---
            Workshop(
                title: "FOUNDER RESILIENCE", 
                topic: "Leadership", 
                description: "Managing the psychology of the founder journey.", 
                scheduledDate: now.addingTimeInterval(3600 * 36),
                icon: "shield.checkered",
                guidingCore: [
                    "TEACHING: Resilience is the ability to maintain cognitive clarity under extreme metabolic and emotional stress. It is a finite resource that must be managed.",
                    "TACTIC: Practice 'Decision Hygiene'. Audit your choices: Were they driven by fear, ego, or logic? Fear is the mind-killer in startups.",
                    "CORE: You are not your startup. Separating your identity from your business results is critical for long-term survival.",
                ],
                outcome: "Fortify the founder psychology.",
                keywords: ["resilience", "fatigue", "regulation", "fear", "hygiene"],
                minWords: 35,
                badge: "RESILIENT_LEADER"
            ),
            Workshop(
                title: "CULTURE AS CODE", 
                topic: "Leadership", 
                description: "Encoding company values into repeatable systems.", 
                scheduledDate: now.addingTimeInterval(3600 * 38),
                icon: "chevron.left.forwardslash.chevron.right",
                guidingCore: [
                    "TEACHING: Culture is what your team does when you are not in the room. It is the operating system that governs every decision in your absence.",
                    "TACTIC: Hire for 'Shared Truths', not just 'Skills'. Skills can be taught; worldviews are immutable.",
                    "CORE: Great cultures are built on radical candor and fast feedback loops. Silence is a sign of a failing culture.",
                ],
                outcome: "Architect a high-performance culture.",
                keywords: ["culture", "hiring", "principles", "feedback", "systems"],
                minWords: 30,
                badge: "CULTURE_CODER"
            ),
            
            // --- MARKETING PILLAR ---
            Workshop(
                title: "RECURSIVE STORYTELLING", 
                topic: "Marketing", 
                description: "Narratives that repeat themselves in the user's mind.", 
                scheduledDate: now.addingTimeInterval(3600 * 40),
                icon: "book.closed.fill",
                guidingCore: [
                    "TEACHING: A great story is a recursive loop. The user experiences it, tells it to themselves, and then tells it to others. The best stories are self-replicating.",
                    "TACTIC: Use the 'Hero's Journey'. Your user is the Hero. You are the Guide (Nexus). Your product is the Lightsaber. Don't try to be the Hero.",
                    "CORE: Facts tell, but stories sell. If your data doesn't have a narrative heart, it won't move people to action.",
                ],
                outcome: "Master self-replicating brand narratives.",
                keywords: ["story", "hero", "narrative", "recursive", "brand"],
                minWords: 35,
                badge: "STORY_WEAVER"
            ),
            Workshop(
                title: "COMMUNITY MOATS", 
                topic: "Marketing", 
                description: "Building defensible networks of engaged advocates.", 
                scheduledDate: now.addingTimeInterval(3600 * 42),
                icon: "person.3.fill",
                guidingCore: [
                    "TEACHING: A community is a group of people who share an identity, not just a product. Identities are significantly harder to copy than features.",
                    "TACTIC: Enable 'User-Generated Value'. Let your users contribute to the platform. Contribution creates loyalty.",
                    "CORE: The strongest communities help each other without you. Your goal is to become unnecessary once the network effect takes over.",
                ],
                outcome: "Architect a loyal community ecosystem.",
                keywords: ["community", "advocate", "identity", "loyalty", "value"],
                minWords: 30,
                badge: "COMMUNITY_SAGE"
            ),
            
            // --- ADVANCED MODULES ---
            Workshop(
                title: "AI TRANSFORMATION", 
                topic: "Innovation", 
                description: "Integrating LLMs into the core product architecture.", 
                scheduledDate: now.addingTimeInterval(3600 * 48),
                icon: "cpu.fill",
                guidingCore: [
                    "TEACHING: AI is a new layer of the internet. It's not a feature; it's a fundamental change in how we process information.",
                    "TACTIC: Find the 'Dumb Step'. What part of your product requires human manual processing that AI could handle instantly?",
                    "CORE: Precision > Generality. A specific AI tool that solves one problem perfectly is 100x more valuable than a general chat app.",
                ],
                outcome: "Leverage AI for structural advantage.",
                keywords: ["ai", "llm", "automation", "architecture", "precision"],
                minWords: 35,
                badge: "AI_EVOLVER"
            ),
            Workshop(
                title: "EXIT ARCHITECTURE", 
                topic: "Leadership", 
                description: "Designing for a multi-billion dollar acquisition.", 
                scheduledDate: now.addingTimeInterval(3600 * 60),
                icon: "door.right.hand.open",
                guidingCore: [
                    "TEACHING: An exit is not an end; it's a transaction of value. You must build your company to be 'Buyable', even if you never intend to sell.",
                    "TACTIC: Understand the 'Strategy' of your potential acquirers. Build the piece of the puzzle they are missing.",
                    "CORE: The best exits are bought, not sold. If you have a great business, the offers will find you.",
                ],
                outcome: "Prepare for high-stakes strategic exits.",
                keywords: ["exit", "acquisition", "valuation", "strategy", "m&a"],
                minWords: 40,
                badge: "STRATEGIC_EXIT_MASTER"
            ),
            Workshop(
                title: "THE NEXUS INITIATIVE", 
                topic: "Mission", 
                description: "Final certification: Synthesizing the entire curriculum.", 
                scheduledDate: now.addingTimeInterval(3600 * 72),
                icon: "shield.fill",
                guidingCore: [
                    "TEACHING: You have traversed the major pillars of evolution. Now you must synthesize them into a single, cohesive strategic force.",
                    "TACTIC: Review your past 'Mission Entries'. Find the pattern. Your unique founder-strategy is your greatest weapon.",
                    "CORE: Evolution is never finished. The goal of the Nexus is to turn you into a perpetual learning machine.",
                ],
                outcome: "Final curriculum synthesis and certification.",
                keywords: ["synthesis", "mastery", "initiation", "nexus", "evolution"],
                minWords: 50,
                badge: "NEXUS_ULTIMATE"
            )
        ]
    }
}

