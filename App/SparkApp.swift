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
            .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}
