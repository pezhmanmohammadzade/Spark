import SwiftUI
import SwiftData

@main
struct SparkApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CBLProject.self,
            CBLStep.self,
            EvolutionSnapshot.self,
            UserStats.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    DashboardView()
                } else {
                    OnboardingView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}
