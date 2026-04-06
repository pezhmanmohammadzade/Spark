import SwiftUI
import SwiftData

public struct TimelineView: View {
    @Query(sort: \CBLProject.createdAt, order: .reverse) private var projects: [CBLProject]
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        ZStack {
            SparkBackground().ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { 
                        HapticManager.shared.triggerSelection()
                        dismiss() 
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.title3.bold())
                            Text("BACK")
                                .font(.system(size: 10, weight: .bold, design: .monospaced)) // Using safe font directly or Typography micro equivalent
                                .tracking(2)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.trailing, 16)
                        .contentShape(Rectangle())
                    }
                    
                    Spacer()
                    
                    Text("EVOLUTION TIMELINE")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(2)
                    
                    Spacer()
                    
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                if projects.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "hurricane")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.1))
                        Text("Your evolution hasn't started yet.")
                            .font(SparkTheme.Typography.body)
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(projects.enumerated()), id: \.element.id) { index, project in
                                TimelineNode(project: project, isLast: index == projects.count - 1)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

public struct TimelineNode: View {
    let project: CBLProject
    let isLast: Bool
    
    private var completion: Double {
        let totalSteps = Double(project.steps.count)
        guard totalSteps > 0 else { return 0 }
        let completed = Double(project.steps.filter { $0.isCompleted }.count)
        return (completed / totalSteps)
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 20) {
            // Timeline Line & Node
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(completion >= 1.0 ? SparkTheme.Colors.xpElectric : .white.opacity(0.1))
                        .frame(width: 16, height: 16)
                    
                    if completion < 1.0 && completion > 0.0 {
                        Circle()
                            .stroke(SparkTheme.Colors.xpElectric, lineWidth: 2)
                            .frame(width: 16, height: 16)
                    }
                }
                
                if !isLast {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 2)
                }
            }
            
            // Content
            GlassCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text(project.createdAt.formatted(date: .long, time: .shortened))
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.4))
                    
                    Text(project.title)
                        .font(SparkTheme.Typography.bentoHeader)
                        .foregroundColor(.white)
                    
                    Text(project.initialIdea)
                        .font(SparkTheme.Typography.body)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                    
                    ProgressView(value: completion)
                        .tint(completion >= 1.0 ? SparkTheme.Colors.xpElectric : .blue)
                        .padding(.top, 8)
                }
            }
            .padding(.bottom, 24)
        }
    }
}
