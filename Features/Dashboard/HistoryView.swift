import SwiftUI
import SwiftData

public struct HistoryView: View {
    @Query(sort: \CBLProject.createdAt, order: .reverse) private var projects: [CBLProject]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var briefingProject: CBLProject?
    @State private var navigatedProject: CBLProject?
    @State private var showClearHistoryAlert = false
    
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
                        
                        if !projects.isEmpty {
                            Button(action: { 
                                HapticManager.shared.triggerSelection()
                                showClearHistoryAlert = true 
                            }) {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red.opacity(0.8))
                                    .padding(8)
                                    .background(Circle().fill(Color.red.opacity(0.1)))
                            }
                        } else {
                            Text("0 ITEMS")
                                .font(SparkTheme.Typography.micro)
                                .foregroundColor(SparkTheme.Colors.xpElectric)
                        }
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
                        List {
                            ForEach(projects) { project in
                                Button(action: {
                                    HapticManager.shared.triggerSelection()
                                    briefingProject = project
                                }) {
                                    HistoryItemCard(project: project)
                                }
                                .buttonStyle(.plain)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
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
            .alert("Clear Mission Logs?", isPresented: $showClearHistoryAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    clearAllHistory()
                }
            } message: {
                Text("This will permanently delete your entire mission history. This action cannot be reversed.")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        HapticManager.shared.triggerSelection()
        for index in offsets {
            modelContext.delete(projects[index])
        }
    }
    
    private func clearAllHistory() {
        HapticManager.shared.triggerSuccess()
        for project in projects {
            modelContext.delete(project)
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
