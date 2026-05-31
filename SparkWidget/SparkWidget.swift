import WidgetKit
import SwiftUI

// ============================================================
// MARK: - Widget Color System (mirrors SparkTheme.Colors)
// ============================================================

enum WidgetColors {
    static let background = Color(red: 0.02, green: 0.03, blue: 0.08)
    static let backgroundAlt = Color(red: 0.05, green: 0.05, blue: 0.12)
    static let accent = Color(hue: 0.6, saturation: 0.8, brightness: 1.0)
    static let levelGold = Color(hue: 0.12, saturation: 0.8, brightness: 1.0)
    static let xpElectric = Color(hue: 0.55, saturation: 0.9, brightness: 1.0)
    static let streakFlame = Color(hue: 0.08, saturation: 0.9, brightness: 1.0)
    static let shieldBlue = Color(hue: 0.58, saturation: 0.7, brightness: 0.95)
    static let engage = Color(hue: 0.6, saturation: 0.8, brightness: 1.0)
    static let investigate = Color(hue: 0.8, saturation: 0.7, brightness: 1.0)
    static let act = Color(hue: 0.15, saturation: 0.9, brightness: 1.0)
    static let glassBorder = Color.white.opacity(0.12)
    static let neuralGreen = Color(hue: 0.38, saturation: 0.85, brightness: 0.9)
}

// ============================================================
// MARK: - Shared Timeline Entry
// ============================================================

struct SparkWidgetEntry: TimelineEntry {
    let date: Date
    let level: Int
    let levelTitle: String
    let currentXP: Int
    let xpForNextLevel: Int
    let dailyStreak: Int
    let streakMultiplier: Double
    let neuralShields: Int
    let activeProjectTitle: String?
    let activeProjectPhase: String?
    let completedSteps: Int
    let totalSteps: Int
    let sparkQuote: String
    let dailyChallenge: String
    
    var streakTier: String {
        switch dailyStreak {
        case 0: return "COLD"
        case 1...2: return "WARM"
        case 3...6: return "HOT"
        case 7...13: return "NOVA"
        case 14...29: return "SUPERNOVA"
        default: return "ETERNAL"
        }
    }
    
    var streakTierColor: Color {
        switch dailyStreak {
        case 0: return .gray
        case 1...2: return .orange.opacity(0.7)
        case 3...6: return WidgetColors.streakFlame
        case 7...13: return .red
        case 14...29: return .purple
        default: return WidgetColors.levelGold
        }
    }
    
    var phaseColor: Color {
        switch (activeProjectPhase ?? "").lowercased() {
        case "engage", "spark": return WidgetColors.engage
        case "investigate", "deep dive": return WidgetColors.investigate
        case "act", "launch": return WidgetColors.act
        default: return WidgetColors.accent
        }
    }
    
    var xpProgress: Double {
        Double(currentXP) / Double(max(xpForNextLevel, 1))
    }
    
    static var placeholder: SparkWidgetEntry {
        SparkWidgetEntry(
            date: Date(),
            level: 5,
            levelTitle: "Spark Architect",
            currentXP: 2400,
            xpForNextLevel: 5000,
            dailyStreak: 7,
            streakMultiplier: 1.25,
            neuralShields: 1,
            activeProjectTitle: "Neural Interface",
            activeProjectPhase: "Investigate",
            completedSteps: 5,
            totalSteps: 10,
            sparkQuote: "● COGNITIVE FRICTION DETECTED. ANALYZING...",
            dailyChallenge: "THE BIG IDEA IS STILL VAGUE. IF NO ONE USES THIS TOMORROW, WHOSE LIFE IS MOST MISERABLE?"
        )
    }
}

// ============================================================
// MARK: - Shared Timeline Provider
// ============================================================

struct SparkWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> SparkWidgetEntry {
        .placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SparkWidgetEntry) -> ()) {
        completion(makeEntry())
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SparkWidgetEntry>) -> ()) {
        let entry = makeEntry()
        // Refresh every 30 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    private func makeEntry() -> SparkWidgetEntry {
        SparkWidgetEntry(
            date: Date(),
            level: SharedWidgetData.level,
            levelTitle: SharedWidgetData.levelTitle,
            currentXP: SharedWidgetData.currentXP,
            xpForNextLevel: SharedWidgetData.xpForNextLevel,
            dailyStreak: SharedWidgetData.dailyStreak,
            streakMultiplier: SharedWidgetData.streakMultiplier,
            neuralShields: SharedWidgetData.neuralShields,
            activeProjectTitle: SharedWidgetData.activeProjectTitle,
            activeProjectPhase: SharedWidgetData.activeProjectPhase,
            completedSteps: SharedWidgetData.completedSteps,
            totalSteps: SharedWidgetData.totalSteps,
            sparkQuote: SharedWidgetData.sparkQuote,
            dailyChallenge: SharedWidgetData.dailyChallenge
        )
    }
}

// ============================================================
// MARK: - Widget #1: Streak & XP (Small)
// ============================================================

struct StreakXPWidgetView: View {
    var entry: SparkWidgetEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top row: SPARK badge + Level
            HStack(alignment: .top) {
                // Streak flame icon
                ZStack {
                    Circle()
                        .fill(entry.streakTierColor.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "flame.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(entry.streakTierColor)
                        .shadow(color: entry.streakTierColor.opacity(0.5), radius: 4)
                }
                
                Spacer()
                
                // Level badge
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [WidgetColors.levelGold, .orange],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 28, height: 28)
                        .shadow(color: WidgetColors.levelGold.opacity(0.4), radius: 4)
                    
                    Text("\(entry.level)")
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .foregroundColor(.black)
                }
            }
            
            Spacer(minLength: 4)
            
            // Streak count
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text("\(entry.dailyStreak)")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                if entry.streakMultiplier > 1.0 {
                    Text("x\(String(format: "%.1f", entry.streakMultiplier))")
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .foregroundColor(WidgetColors.xpElectric)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(WidgetColors.xpElectric.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            
            // Streak tier + shields
            HStack(spacing: 6) {
                Text(entry.streakTier)
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .foregroundColor(entry.streakTierColor)
                    .tracking(1)
                
                if entry.neuralShields > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 7, weight: .bold))
                        Text("\(entry.neuralShields)")
                            .font(.system(size: 7, weight: .black, design: .rounded))
                    }
                    .foregroundColor(WidgetColors.shieldBlue)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(WidgetColors.shieldBlue.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                }
            }
            
            Spacer(minLength: 6)
            
            // XP Progress bar
            VStack(alignment: .leading, spacing: 3) {
                Text("\(entry.currentXP)/\(entry.xpForNextLevel) XP")
                    .font(.system(size: 8, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                            .frame(height: 5)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [WidgetColors.xpElectric, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(0, geo.size.width * entry.xpProgress), height: 5)
                            .shadow(color: WidgetColors.xpElectric.opacity(0.4), radius: 3)
                    }
                }
                .frame(height: 5)
            }
        }
        .padding(14)
        .containerBackground(for: .widget) {
            ZStack {
                WidgetColors.background
                
                // Subtle gradient accent
                LinearGradient(
                    colors: [entry.streakTierColor.opacity(0.08), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}

struct StreakXPWidget: Widget {
    let kind: String = "StreakXPWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SparkWidgetProvider()) { entry in
            StreakXPWidgetView(entry: entry)
        }
        .configurationDisplayName("Streak & XP")
        .description("Your daily streak, level, and XP progress at a glance.")
        .supportedFamilies([.systemSmall])
    }
}

// ============================================================
// MARK: - Widget #2: Mission Command (Medium)
// ============================================================

struct MissionCommandWidgetView: View {
    var entry: SparkWidgetEntry
    
    private var hasProject: Bool {
        entry.activeProjectTitle != nil && !(entry.activeProjectTitle?.isEmpty ?? true)
    }
    
    private var completionProgress: Double {
        guard entry.totalSteps > 0 else { return 0 }
        return Double(entry.completedSteps) / Double(entry.totalSteps)
    }
    
    var body: some View {
        if hasProject {
            activeProjectView
        } else {
            noProjectView
        }
    }
    
    private var activeProjectView: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "scope")
                        .font(.system(size: 9, weight: .bold))
                    Text("MISSION COMMAND")
                        .font(.system(size: 9, weight: .black, design: .rounded))
                        .tracking(1)
                }
                .foregroundColor(WidgetColors.accent.opacity(0.7))
                
                Spacer()
                
                // Phase badge
                if let phase = entry.activeProjectPhase {
                    Text(phase.uppercased())
                        .font(.system(size: 8, weight: .black, design: .rounded))
                        .foregroundColor(entry.phaseColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(entry.phaseColor.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            
            Spacer(minLength: 8)
            
            // Project title
            Text(entry.activeProjectTitle ?? "")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
            
            Spacer(minLength: 8)
            
            // Progress section
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("\(entry.completedSteps)/\(entry.totalSteps) STEPS")
                        .font(.system(size: 9, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                        .tracking(0.5)
                    
                    Spacer()
                    
                    Text("\(Int(completionProgress * 100))%")
                        .font(.system(size: 11, weight: .black, design: .rounded))
                        .foregroundColor(entry.phaseColor)
                }
                
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [entry.phaseColor, entry.phaseColor.opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(0, geo.size.width * completionProgress), height: 6)
                            .shadow(color: entry.phaseColor.opacity(0.4), radius: 4)
                    }
                }
                .frame(height: 6)
                
                // Phase dots
                HStack(spacing: 4) {
                    phaseDot("ENGAGE", WidgetColors.engage, isActive: entry.activeProjectPhase?.lowercased() == "engage" || entry.activeProjectPhase?.lowercased() == "spark")
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 1)
                    
                    phaseDot("INVESTIGATE", WidgetColors.investigate, isActive: entry.activeProjectPhase?.lowercased() == "investigate" || entry.activeProjectPhase?.lowercased() == "deep dive")
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 1)
                    
                    phaseDot("ACT", WidgetColors.act, isActive: entry.activeProjectPhase?.lowercased() == "act" || entry.activeProjectPhase?.lowercased() == "launch")
                }
            }
        }
        .padding(14)
        .containerBackground(for: .widget) {
            ZStack {
                WidgetColors.background
                
                LinearGradient(
                    colors: [entry.phaseColor.opacity(0.06), .clear],
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
            }
        }
    }
    
    private func phaseDot(_ label: String, _ color: Color, isActive: Bool) -> some View {
        VStack(spacing: 2) {
            Circle()
                .fill(isActive ? color : color.opacity(0.2))
                .frame(width: 6, height: 6)
                .shadow(color: isActive ? color.opacity(0.5) : .clear, radius: 3)
            Text(label)
                .font(.system(size: 6, weight: .bold, design: .rounded))
                .foregroundColor(isActive ? color : .white.opacity(0.3))
        }
    }
    
    private var noProjectView: some View {
        VStack(spacing: 8) {
            Image(systemName: "scope")
                .font(.system(size: 28, weight: .light))
                .foregroundColor(WidgetColors.accent.opacity(0.3))
            
            Text("NO ACTIVE MISSION")
                .font(.system(size: 11, weight: .black, design: .rounded))
                .foregroundColor(.white.opacity(0.4))
                .tracking(1)
            
            Text("Tap to ignite a new Spark")
                .font(.system(size: 9, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.25))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            WidgetColors.background
        }
    }
}

struct MissionCommandWidget: Widget {
    let kind: String = "MissionCommandWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SparkWidgetProvider()) { entry in
            MissionCommandWidgetView(entry: entry)
        }
        .configurationDisplayName("Mission Command")
        .description("Track your active CBL mission progress.")
        .supportedFamilies([.systemMedium])
    }
}

// ============================================================
// MARK: - Widget #3: SPARK Quote (Small)
// ============================================================

struct SparkQuoteWidgetView: View {
    var entry: SparkWidgetEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 4) {
                Circle()
                    .fill(WidgetColors.neuralGreen)
                    .frame(width: 5, height: 5)
                    .shadow(color: WidgetColors.neuralGreen.opacity(0.6), radius: 3)
                
                Text("SPARK")
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .foregroundColor(WidgetColors.neuralGreen.opacity(0.8))
                    .tracking(2)
                
                Spacer()
                
                Text(entry.date, style: .time)
                    .font(.system(size: 7, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.25))
            }
            
            Spacer(minLength: 8)
            
            // Quote
            Text(entry.sparkQuote)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(.white.opacity(0.85))
                .lineLimit(5)
                .minimumScaleFactor(0.7)
                .lineSpacing(2)
            
            Spacer()
            
            // Bottom: terminal cursor effect
            HStack(spacing: 3) {
                Rectangle()
                    .fill(WidgetColors.neuralGreen.opacity(0.4))
                    .frame(width: 6, height: 10)
                
                Text("TRANSMISSION ACTIVE")
                    .font(.system(size: 6, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.15))
                    .tracking(1)
            }
        }
        .padding(14)
        .containerBackground(for: .widget) {
            ZStack {
                WidgetColors.background
                
                // Scanline effect
                VStack(spacing: 3) {
                    ForEach(0..<40, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.white.opacity(0.01))
                            .frame(height: 1)
                        Spacer(minLength: 0)
                    }
                }
                
                // Corner glow
                LinearGradient(
                    colors: [WidgetColors.neuralGreen.opacity(0.04), .clear],
                    startPoint: .topLeading,
                    endPoint: .center
                )
            }
        }
    }
}

struct SparkQuoteWidget: Widget {
    let kind: String = "SparkQuoteWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SparkWidgetProvider()) { entry in
            SparkQuoteWidgetView(entry: entry)
        }
        .configurationDisplayName("SPARK Transmission")
        .description("Tactical provocations from the SPARK AI persona.")
        .supportedFamilies([.systemSmall])
    }
}

// ============================================================
// MARK: - Widget #4: Nexus Vitals (Medium)
// ============================================================

struct NexusVitalsWidgetView: View {
    var entry: SparkWidgetEntry
    
    var body: some View {
        HStack(spacing: 14) {
            // Left column: Level orb
            VStack(spacing: 8) {
                ZStack {
                    // Outer ring
                    Circle()
                        .stroke(WidgetColors.levelGold.opacity(0.2), lineWidth: 2)
                        .frame(width: 56, height: 56)
                    
                    // Inner filled circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [WidgetColors.levelGold, .orange.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 46, height: 46)
                        .shadow(color: WidgetColors.levelGold.opacity(0.4), radius: 8)
                    
                    Text("\(entry.level)")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.black)
                }
                
                Text(entry.levelTitle.uppercased())
                    .font(.system(size: 7, weight: .bold, design: .rounded))
                    .foregroundColor(WidgetColors.levelGold.opacity(0.7))
                    .tracking(0.5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(width: 70)
            
            // Right column: Stats
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    Text("NEXUS VITALS")
                        .font(.system(size: 9, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(1)
                    
                    Spacer()
                    
                    // Multiplier
                    if entry.streakMultiplier > 1.0 {
                        HStack(spacing: 2) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 7))
                            Text("x\(String(format: "%.1f", entry.streakMultiplier))")
                                .font(.system(size: 9, weight: .black, design: .rounded))
                        }
                        .foregroundColor(WidgetColors.xpElectric)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(WidgetColors.xpElectric.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                
                Spacer(minLength: 6)
                
                // XP bar
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text("XP")
                            .font(.system(size: 8, weight: .black, design: .rounded))
                            .foregroundColor(WidgetColors.xpElectric.opacity(0.7))
                        
                        Spacer()
                        
                        Text("\(entry.currentXP)/\(entry.xpForNextLevel)")
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 6)
                            
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [WidgetColors.xpElectric, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: max(0, geo.size.width * entry.xpProgress), height: 6)
                                .shadow(color: WidgetColors.xpElectric.opacity(0.4), radius: 3)
                        }
                    }
                    .frame(height: 6)
                }
                
                Spacer(minLength: 8)
                
                // Streak + Shields row
                HStack(spacing: 10) {
                    // Streak
                    HStack(spacing: 5) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(entry.streakTierColor)
                            .shadow(color: entry.streakTierColor.opacity(0.4), radius: 3)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("\(entry.dailyStreak)")
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(entry.streakTier)
                                .font(.system(size: 7, weight: .bold, design: .rounded))
                                .foregroundColor(entry.streakTierColor.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                    
                    // Neural Shields
                    if entry.neuralShields > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "shield.checkered")
                                .font(.system(size: 10, weight: .bold))
                            
                            Text("\(entry.neuralShields)")
                                .font(.system(size: 12, weight: .black, design: .rounded))
                        }
                        .foregroundColor(WidgetColors.shieldBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(WidgetColors.shieldBlue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
        .padding(14)
        .containerBackground(for: .widget) {
            ZStack {
                WidgetColors.background
                
                // Subtle radial glow from level orb
                RadialGradient(
                    colors: [WidgetColors.levelGold.opacity(0.06), .clear],
                    center: .leading,
                    startRadius: 20,
                    endRadius: 150
                )
            }
        }
    }
}

struct NexusVitalsWidget: Widget {
    let kind: String = "NexusVitalsWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SparkWidgetProvider()) { entry in
            NexusVitalsWidgetView(entry: entry)
        }
        .configurationDisplayName("Nexus Vitals")
        .description("Your complete Spark dashboard: Level, XP, Streak, and Shields.")
        .supportedFamilies([.systemMedium])
    }
}

// ============================================================
// MARK: - Widget #5: Daily Challenge (Small)
// ============================================================

struct DailyChallengeWidgetView: View {
    var entry: SparkWidgetEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 4) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(WidgetColors.streakFlame)
                
                Text("CHALLENGE")
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .foregroundColor(WidgetColors.streakFlame.opacity(0.8))
                    .tracking(1)
                
                Spacer()
                
                // Pulsing dot
                Circle()
                    .fill(WidgetColors.streakFlame)
                    .frame(width: 4, height: 4)
                    .shadow(color: WidgetColors.streakFlame.opacity(0.6), radius: 3)
            }
            
            Spacer(minLength: 8)
            
            // Challenge text
            Text(entry.dailyChallenge)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(5)
                .minimumScaleFactor(0.65)
                .lineSpacing(2)
            
            Spacer()
            
            // Footer
            HStack {
                Text("TAP TO EVOLVE")
                    .font(.system(size: 7, weight: .black, design: .rounded))
                    .foregroundColor(WidgetColors.streakFlame.opacity(0.3))
                    .tracking(1.5)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(WidgetColors.streakFlame.opacity(0.3))
            }
        }
        .padding(14)
        .containerBackground(for: .widget) {
            ZStack {
                WidgetColors.background
                
                // Danger gradient
                LinearGradient(
                    colors: [WidgetColors.streakFlame.opacity(0.06), .clear, WidgetColors.streakFlame.opacity(0.03)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Top border accent
                VStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [WidgetColors.streakFlame.opacity(0.3), WidgetColors.streakFlame.opacity(0.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                    Spacer()
                }
            }
        }
    }
}

struct DailyChallengeWidget: Widget {
    let kind: String = "DailyChallengeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SparkWidgetProvider()) { entry in
            DailyChallengeWidgetView(entry: entry)
        }
        .configurationDisplayName("Daily Challenge")
        .description("A provocative Socratic challenge to push your thinking.")
        .supportedFamilies([.systemSmall])
    }
}

// ============================================================
// MARK: - Widget Bundle
// ============================================================

@main
struct SparkWidgetBundle: WidgetBundle {
    var body: some Widget {
        StreakXPWidget()
        MissionCommandWidget()
        SparkQuoteWidget()
        NexusVitalsWidget()
        DailyChallengeWidget()
    }
}
