import SwiftUI
import SwiftData
import WidgetKit

@main
struct SparkApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CBLProject.self,
            CBLStep.self,
            EvolutionSnapshot.self,
            Workshop.self,
            UserStats.self,
            Trophy.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State private var isSplashScreenFinished: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                DashboardView()
                
                if !isSplashScreenFinished {
                    SparkSplashScreenView(onFinished: {
                        withAnimation {
                            isSplashScreenFinished = true
                        }
                    })
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
            .ignoresSafeArea()
            .preferredColorScheme(.dark)
            .onAppear {
                syncWidgetData(container: sharedModelContainer)
            }
            .onChange(of: isSplashScreenFinished) {
                syncWidgetData(container: sharedModelContainer)
            }
        }
        .modelContainer(sharedModelContainer)
    }
    
    // MARK: - Widget Data Sync
    
    @MainActor
    private func syncWidgetData(container: ModelContainer) {
        let context = container.mainContext
        
        // Sync UserStats
        if let stats = try? context.fetch(FetchDescriptor<UserStats>()).first {
            SharedWidgetData.syncStats(
                level: stats.level,
                levelTitle: stats.levelTitle,
                currentXP: stats.currentXP,
                xpForNextLevel: stats.xpForNextLevel,
                dailyStreak: stats.dailyStreak,
                streakMultiplier: stats.streakMultiplier,
                neuralShields: stats.neuralShields
            )
            
            // Sync challenge based on latest project
            if let project = try? context.fetch(FetchDescriptor<CBLProject>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])).first {
                let completed = project.steps.filter { $0.isCompleted }.count
                let total = project.steps.count
                
                // Determine current phase
                let phase: String
                let engageTypes = ["Big Idea", "Essential Question", "Challenge"]
                let investigateTypes = ["Guiding Questions", "Guiding Activities", "Guiding Resources", "Synthesis"]
                
                let engageCompletion = project.completionForPhase(types: engageTypes)
                let investigateCompletion = project.completionForPhase(types: investigateTypes)
                
                if engageCompletion < 1.0 {
                    phase = "Engage"
                } else if investigateCompletion < 1.0 {
                    phase = "Investigate"
                } else {
                    phase = "Act"
                }
                
                SharedWidgetData.syncProject(
                    title: project.title,
                    phase: phase,
                    completedSteps: completed,
                    totalSteps: total
                )
                
                // Sync proactive challenge
                let challenge = AIService.shared.generateProactiveChallenge(project: project)
                SharedWidgetData.syncChallenge(challenge)
            } else {
                SharedWidgetData.syncProject(title: nil, phase: nil, completedSteps: 0, totalSteps: 0)
            }
        }
        
        // Sync a random SPARK quote
        let quote = AIService.shared.getRandomSparkQuote()
        SharedWidgetData.syncQuote(quote)
        
        // Reload all widget timelines
        SharedWidgetData.reloadWidgets()
    }
}
