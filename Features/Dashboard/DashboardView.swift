import SwiftUI
import SwiftData

public struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var projects: [CBLProject]
    @Query private var stats: [UserStats]
    @Query private var workshops: [Workshop]
    
    public init() {}
    
    private var currentUserStats: UserStats {
        if let first = stats.first {
            return first
        } else {
            let newStats = UserStats()
            modelContext.insert(newStats)
            return newStats
        }
    }
    
    // Bento Grid Configuration
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State private var navigatedProject: CBLProject? // Programmatic navigation trigger
    @State private var briefingProject: CBLProject? // Project currently being briefed
    @State private var showHistory = false
    @Namespace private var heroNamespace // Matched Geometry
    
    private var totalInsights: Int {
        projects.flatMap { $0.steps }.filter { !$0.aiInsight.isEmpty }.count
    }
    
    private var totalTargetsMET: Int {
        projects.filter { project in
            project.steps.contains { $0.type == "Solution Concept" && $0.isCompleted }
        }.count
    }
    
    private var allWorkshopsCompleted: Bool {
        !workshops.isEmpty && workshops.allSatisfy { $0.isCompleted }
    }
    
    public var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    // Persistent Background
                    SparkBackground()
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                    
                    VStack(spacing: 0) {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 24) {
                                // Brand Header
                                HStack(spacing: 12) {
                                    // Using system image since AppLogo might be missing in some builds
                                    Image(systemName: "sparkles")
                                        .font(.title2)
                                        .foregroundColor(SparkTheme.Colors.xpElectric)
                                        .frame(width: 44, height: 44)
                                        .background(Circle().fill(Color.white.opacity(0.1)))
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("SPARK")
                                            .font(.system(size: 24, weight: .black, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    
                                    Button(action: { 
                                        HapticManager.shared.triggerSelection()
                                        showHistory = true 
                                    }) {
                                        Image(systemName: "clock.arrow.circlepath")
                                            .font(.title3.bold())
                                            .foregroundColor(.white)
                                            .frame(width: 44, height: 44)
                                            .background(Circle().fill(Color.white.opacity(0.1)))
                                    }
                                }
                                .padding(.top, geo.safeAreaInsets.top > 0 ? geo.safeAreaInsets.top : 20)
                                
                                NexusMasteryBanner(
                                    completedCount: workshops.filter { $0.isCompleted }.count,
                                    totalCount: workshops.count
                                )
                                .transition(.move(edge: .top).combined(with: .opacity))

                                // Header & Progress
                                XPProgressHeader(stats: currentUserStats)
                                
                                // IDEA SPARK ENGINE
                                IdeaSparkBox(onSpark: { (newProject: CBLProject) in
                                    briefingProject = newProject
                                })
                                
                                // SPARK TACTICAL FEED
                                SparkTacticalFeed()
                                    .padding(.bottom, 8)
                                
                                // AI WORKSHOP SCHEDULE
                                WorkshopScheduleSection()
                                    .padding(.bottom, 8)
                                
                                // SKILL MASTERY SECTION
                                SkillMasterySection()
                                    .padding(.bottom, 16)
                                
                                // Bento Grid
                                LazyVGrid(columns: columns, spacing: 16) {
                                    if let activeProject = projects.first {
                                        Button(action: {
                                            HapticManager.shared.triggerSelection()
                                            briefingProject = activeProject
                                        }) {
                                            HeroBentoCard(project: activeProject)
                                                .matchedGeometryEffect(id: "hero_card", in: heroNamespace)
                                        }
                                        .buttonStyle(.plain)
                                        .gridCellColumns(2)
                                    } else {
                                        NewProjectBento()
                                            .gridCellColumns(2)
                                    }
                                    
                                    StreakCard(streak: currentUserStats.dailyStreak)
                                    
                                    AdvancedStatCard(
                                        title: "Insights",
                                        value: "\(totalInsights)",
                                        icon: "brain.head.profile",
                                        color: .purple,
                                        trend: totalInsights > 0 ? "LIVE" : nil
                                    )
                                    
                                    AdvancedStatCard(
                                        title: "Target MET",
                                        value: "\(totalTargetsMET)",
                                        icon: "target",
                                        color: .green,
                                        trend: projects.count > 0 ? "\(Int(Double(totalTargetsMET)/Double(max(projects.count, 1)) * 100))%" : nil
                                    )
                                    .gridCellColumns(2)
                                }
                                
                                Spacer(minLength: 140)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    // Sticky Action Button
                    VStack {
                        Spacer()
                        resumeButton
                            .padding(.horizontal, 24)
                            .padding(.bottom, 10)
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .toolbar(.hidden)
            .sheet(item: $briefingProject) { (project: CBLProject) in
                MissionBriefingView(project: project) {
                    briefingProject = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigatedProject = project
                    }
                }
            }
            .fullScreenCover(isPresented: $showHistory) {
                HistoryView()
            }
            .navigationDestination(item: $navigatedProject) { (p: CBLProject) in
                PhaseGateNavigation(project: p)
            }
        }
    }
    
    private var resumeButton: some View {
        Button(action: {
            HapticManager.shared.triggerSelection()
            if let firstProject = projects.first {
                briefingProject = firstProject
            } else {
                let newP = CBLProject(title: "New Discovery")
                newP.generateDefaultSteps()
                modelContext.insert(newP)
                briefingProject = newP
            }
        }) {
            HStack {
                Text("Launch Studio")
                    .font(.headline)
                    .fontWeight(.black)
                Spacer()
                Image(systemName: "sparkles")
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .background(Capsule().fill(Color.white))
            .foregroundColor(.black)
            .shadow(color: .white.opacity(0.3), radius: 15)
        }
    }
}

// MARK: - Mastery Certificate

struct NexusMasteryBanner: View {
    let completedCount: Int
    let totalCount: Int
    
    private var isUnlocked: Bool {
        totalCount > 0 && completedCount == totalCount
    }
    
    private var progress: Double {
        totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
    }
    
    var body: some View {
        GlassCard() {
            VStack(spacing: 12) {
                if isUnlocked {
                    HStack {
                        Image(systemName: "seal.fill")
                            .font(.title2)
                            .foregroundColor(SparkTheme.Colors.xpElectric)
                            .symbolEffect(.pulse)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("CERTIFIED STRATEGIC MENACE")
                                .font(SparkTheme.Typography.micro)
                                .foregroundColor(SparkTheme.Colors.xpElectric)
                                .tracking(2)
                            
                            Text("NEXUS MASTER DIPLOMA")
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "sparkles")
                            .foregroundColor(SparkTheme.Colors.xpElectric)
                    }
                    
                    Text("Congratulations. You are now officially smarter than 98% of your competitors. The Void has been successfully disrupted.")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("MASTERY_CERTIFICATION_IN_PROGRESS")
                                .font(SparkTheme.Typography.micro)
                                .foregroundColor(.white.opacity(0.6))
                                .tracking(2)
                            
                            Spacer()
                            
                            Text("\(completedCount)/\(totalCount) MASTERED")
                                .font(SparkTheme.Typography.micro)
                                .foregroundColor(SparkTheme.Colors.xpElectric)
                        }
                        
                        // Tactical Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 6)
                                
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [SparkTheme.Colors.xpElectric, Color.blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * progress, height: 6)
                                    .shadow(color: SparkTheme.Colors.xpElectric.opacity(0.5), radius: 4)
                            }
                        }
                        .frame(height: 6)
                        
                        Text("Current tactical data insufficient for certification. Proceed with transmissions to evolve.")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(SparkTheme.Colors.xpElectric.opacity(0.7))
                    }
                }
            }
        }
        .onAppear {
            if isUnlocked {
                HapticManager.shared.triggerSuccess()
            }
        }
    }
}

// MARK: - Skill Mastery Section

struct SkillMasterySection: View {
    @Query private var workshops: [Workshop]
    
    var masteredWorkshops: [Workshop] {
        workshops.filter { $0.isCompleted && !$0.masteryBadge.isEmpty }
    }
    
    var body: some View {
        if !masteredWorkshops.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "medal.fill")
                        .foregroundColor(SparkTheme.Colors.levelGold)
                    Text("YOUR_SKILL_MASTERY")
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(2)
                }
                .padding(.horizontal, 4)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(masteredWorkshops) { workshop in
                            MasteryBadgeCard(workshop: workshop)
                        }
                    }
                }
            }
        }
    }
}

struct MasteryBadgeCard: View {
    let workshop: Workshop
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ZStack {
                Circle()
                    .fill(SparkTheme.Colors.levelGold.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: workshop.topicIcon)
                    .font(.title2)
                    .foregroundColor(SparkTheme.Colors.levelGold)
            }
            .overlay {
                Circle()
                    .stroke(SparkTheme.Colors.levelGold.opacity(0.3), lineWidth: 1)
            }
            
            Text(workshop.masteryBadge.replacingOccurrences(of: "_", with: " "))
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                }
        }
    }
}

struct SparkTacticalFeed: View {
    @State private var currentQuote: String = AIService.shared.getRandomSparkQuote()
    let timer = Timer.publish(every: 8.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GlassCard() {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(SparkTheme.Colors.xpElectric)
                            .symbolEffect(.pulse)
                        Text("SPARK_TACTICAL_FEED")
                            .font(SparkTheme.Typography.micro)
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(2)
                    }
                    
                    Text(currentQuote)
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                currentQuote = AIService.shared.getRandomSparkQuote()
            }
        }
    }
}

// MARK: - Bento Components

struct HeroBentoCard: View {
    let project: CBLProject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("CURRENT CHALLENGE")
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(SparkTheme.Colors.xpElectric)
                    .tracking(2)
                Spacer()
                // Active Pulse for Spark's Insight
                Image(systemName: "brain.head.profile")
                    .font(.caption)
                    .foregroundColor(SparkTheme.Colors.xpElectric)
                    .symbolEffect(.pulse)
            }
            
            Text(project.title)
                .font(SparkTheme.Typography.bentoHeader)
                .foregroundColor(.white)
                .lineLimit(2)
            
            HStack {
                Capsule()
                    .fill(SparkTheme.Colors.engage.opacity(0.2))
                    .frame(width: 80, height: 24)
                    .overlay(Text("ADVENTURE").font(.system(size: 8, weight: .bold)).foregroundColor(SparkTheme.Colors.engage))
                
                Spacer()
                
                Text("\(Int(Double(project.steps.filter { $0.isCompleted }.count) / Double(max(project.steps.count, 1)) * 100))%")
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .bentoStyle()
    }
}

struct NewProjectBento: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 16) {
            Text("NO ACTIVE PROJECT")
                .font(SparkTheme.Typography.micro)
                .foregroundColor(.gray)
            
            Button("START NEW QUEST") {
                let p = CBLProject(title: "Future of Mars")
                p.generateDefaultSteps()
                modelContext.insert(p)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .bentoStyle()
    }
}

struct IdeaSparkBox: View {
    @Environment(\.modelContext) private var modelContext
    @State private var rawIdea: String = ""
    @State private var isSparking: Bool = false
    var onSpark: (CBLProject) -> Void
    
    var body: some View {
        GlassCard() {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                    Text("IDEA SPARK")
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(2)
                    Spacer()
                }
                
                TextField("What's on your mind? (e.g. A park on Mars)", text: $rawIdea, axis: .vertical)
                    .font(SparkTheme.Typography.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .lineLimit(2...4)
                
                Button(action: sparkMission) {
                    HStack {
                        if isSparking {
                            ProgressView()
                                .tint(.black)
                                .padding(.trailing, 8)
                            Text("STRUCTURING...")
                        } else {
                            Text("SPARK MISSION")
                            Spacer()
                            Image(systemName: "bolt.fill")
                        }
                    }
                    .font(.caption.bold())
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(rawIdea.isEmpty ? Color.gray : SparkTheme.Colors.xpElectric)
                    .cornerRadius(12)
                }
                .disabled(rawIdea.isEmpty || isSparking)
            }
        }
    }
    
    private func sparkMission() {
        isSparking = true
        HapticManager.shared.triggerImpact(1)
        
        Task {
            let result = await AIService.shared.structureMission(rawInput: rawIdea)
            await MainActor.run {
                let newP = CBLProject(title: result.title, initialIdea: result.idea, description: result.mission)
                newP.generateDefaultSteps()
                modelContext.insert(newP)
                withAnimation {
                    isSparking = false
                    rawIdea = ""
                    onSpark(newP)
                }
            }
        }
    }
}
