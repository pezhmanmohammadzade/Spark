import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var projects: [CBLProject]
    @Query private var stats: [UserStats]
    
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
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    // Persistent Background (Mathematically locked)
                    SparkBackground()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .allowsHitTesting(false)
                    
                    VStack(spacing: 0) {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 24) {
                                // Brand Header
                                HStack(spacing: 12) {
                                    Image("AppLogo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 44, height: 44)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("SPARK")
                                            .font(.system(size: 24, weight: .black, design: .rounded))
                                            .foregroundColor(.white)
                                            .tracking(2)
                                        Text("NEXUS ENGINE v1.0")
                                            .font(.system(size: 8, weight: .bold))
                                            .foregroundColor(SparkTheme.Colors.xpElectric)
                                            .tracking(1)
                                    }
                                    Spacer()
                                }
                                .padding(.top, 20)

                                // Header & Progress
                                XPProgressHeader(stats: currentUserStats)
                                
                                // NEW: Idea Spark Engine
                                IdeaSparkBox(onSpark: { newProject in
                                    navigatedProject = newProject
                                })
                                
                                // Bento Grid
                                LazyVGrid(columns: columns, spacing: 16) {
                                    if let activeProject = projects.first {
                                        NavigationLink(destination: PhaseGateNavigation(project: activeProject)) {
                                            HeroBentoCard(project: activeProject)
                                        }
                                        .buttonStyle(.plain)
                                        .gridCellColumns(2)
                                        .accessibilityLabel("Current Mission: \(activeProject.title)")
                                        .accessibilityHint("Tap to resume your quest.")
                                    } else {
                                        NewProjectBento()
                                            .gridCellColumns(2)
                                            .accessibilityLabel("No active mission")
                                            .accessibilityHint("Tap to start your first discovery.")
                                    }
                                    
                                    StreakCard(streak: currentUserStats.dailyStreak)
                                        .accessibilityLabel("\(currentUserStats.dailyStreak) Day Streak")
                                    
                                    BentoStatCard(title: "Insights", value: "8", icon: "brain.head.profile", color: .purple)
                                        .accessibilityLabel("8 Strategic Insights found")
                                    
                                    BentoStatCard(title: "Target", value: "3", icon: "target", color: .green)
                                        .gridCellColumns(2)
                                        .accessibilityLabel("3 Missions in progress")
                                }
                                
                                Spacer(minLength: 140)
                            }
                            .padding(.horizontal, 20)
                            .frame(width: geo.size.width) // Constraint check
                        }
                    }
                    
                    // Sticky Action Button (Bottom Locked)
                    VStack {
                        Spacer()
                        resumeButton
                            .padding(.horizontal, 24)
                            .padding(.bottom, 10)
                            .frame(width: geo.size.width) // Constraint check
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped() // Hard-Lock everything inside
            }
            .navigationDestination(item: $navigatedProject) { project in
                PhaseGateNavigation(project: project)
            }
            .toolbar(.hidden)
        }
    }
    
    private var resumeButton: some View {
        Button(action: {
            HapticManager.shared.triggerSelection()
            if let firstProject = projects.first {
                navigatedProject = firstProject
            } else {
                // Emergency Recovery: If query is still loading, create and navigate
                let newP = CBLProject(title: "New Discovery")
                modelContext.insert(newP)
                navigatedProject = newP
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
        .onChange(of: navigatedProject) { _, _ in
            HapticManager.shared.triggerSelection()
        }
    }
}

// MARK: - Bento Components (Self-Contained)

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
                Image(systemName: "arrow.up.forward.circle.fill")
                    .foregroundColor(.white.opacity(0.3))
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
                
                Text("65%")
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .bentoStyle()
    }
}

struct BentoStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Text(title.uppercased())
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
                modelContext.insert(p)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .frame(maxWidth: .infinity)
        .bentoStyle()
    }
}

struct IdeaSparkBox: View {
    @Environment(\.modelContext) private var modelContext
    @State private var rawIdea: String = ""
    @State private var isSparking: Bool = false
    var onSpark: (CBLProject) -> Void
    
    var body: some View {
        GlassCard {
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
        .padding(.bottom, 24)
    }
    
    private func sparkMission() {
        isSparking = true
        HapticManager.shared.triggerImpact(.medium)
        
        Task {
            let result = await AIService.shared.structureMission(rawInput: rawIdea)
            
            await MainActor.run {
                let newProject = CBLProject(title: result.title, description: result.description)
                modelContext.insert(newProject)
                
                withAnimation {
                    isSparking = false
                    rawIdea = ""
                    onSpark(newProject)
                }
            }
        }
    }
}
