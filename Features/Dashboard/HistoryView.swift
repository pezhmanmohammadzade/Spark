import SwiftUI
import SwiftData

public struct HistoryView: View {
    @Query(sort: \CBLProject.createdAt, order: .reverse) private var projects: [CBLProject]
    @Environment(\.dismiss) private var dismiss
    
    @State private var briefingProject: CBLProject?
    @State private var navigatedProject: CBLProject?
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                SparkBackground()
                
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
                                    .font(SparkTheme.Typography.micro)
                                    .tracking(2)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.trailing, 16)
                            .contentShape(Rectangle())
                        }
                        
                        Spacer()
                        
                        Text("MISSION LOGS")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(2)
                        
                        Spacer()
                        
                        Text("\(projects.count) ITEMS")
                            .font(SparkTheme.Typography.micro)
                            .foregroundColor(SparkTheme.Colors.xpElectric)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                    
                    if projects.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "tray.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.1))
                            Text("No history found in the Spark archives.")
                                .font(SparkTheme.Typography.body)
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 16) {
                                ForEach(projects) { project in
                                    Button(action: {
                                        HapticManager.shared.triggerSelection()
                                        briefingProject = project
                                    }) {
                                        HistoryItemCard(project: project)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $briefingProject) { project in
                MissionBriefingView(project: project) {
                    briefingProject = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigatedProject = project
                    }
                }
            }
            .navigationDestination(item: $navigatedProject) { project in
                PhaseGateNavigation(project: project)
            }
        }
    }
}

struct HistoryItemCard: View {
    let project: CBLProject
    
    private var completion: Double {
        let totalSteps = Double(project.steps.count)
        guard totalSteps > 0 else { return 0 }
        let completed = Double(project.steps.filter { $0.isCompleted }.count)
        return (completed / totalSteps) * 100
    }
    
    var body: some View {
        GlassCard(cornerRadius: 20) {
            HStack(spacing: 16) {
                // Progress Circle
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.05), lineWidth: 4)
                    Circle()
                        .trim(from: 0, to: CGFloat(completion / 100))
                        .stroke(
                            LinearGradient(colors: [SparkTheme.Colors.xpElectric, .blue], startPoint: .top, endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(completion))%")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.title)
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack {
                        Text(project.createdAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.4))
                        
                        Spacer()
                        
                        Text(project.steps.first?.type ?? "Mission")
                            .font(.system(size: 8, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(SparkTheme.Colors.xpElectric.opacity(0.2))
                            .foregroundColor(SparkTheme.Colors.xpElectric)
                            .cornerRadius(4)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.2))
            }
        }
    }
}
