import SwiftUI
import SwiftData

public struct MissionBriefingView: View {
    public let project: CBLProject
    public var onBegin: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    public init(project: CBLProject, onBegin: @escaping () -> Void) {
        self.project = project
        self.onBegin = onBegin
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                SparkBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Mission Header
                    VStack(spacing: 12) {
                        Image(systemName: "bolt.ring.closed")
                            .font(.system(size: 60))
                            .foregroundColor(SparkTheme.Colors.xpElectric)
                            .symbolEffect(.pulse)
                        
                        Text("MISSION_BRIEFING")
                            .font(SparkTheme.Typography.micro)
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(4)
                    }
                    .padding(.top, geo.safeAreaInsets.top > 0 ? geo.safeAreaInsets.top : 20)
                    
                    // Project Title
                    Text(project.title.uppercased())
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Mission Details
                    GlassCard {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                briefingSection(title: "INITIAL_IDEA", content: project.initialIdea, icon: "lightbulb.fill")
                                
                                Divider().background(Color.white.opacity(0.1))
                                
                                briefingSection(title: "CORE_MISSION", content: project.projectDescription, icon: "target")
                            }
                            .padding(10)
                        }
                    }
                    .frame(maxHeight: 400)
                    
                    Spacer()
                    
                    // Action
                    Button(action: {
                        HapticManager.shared.triggerSuccess()
                        onBegin()
                    }) {
                        HStack {
                            Text("BEGIN EVOLUTION")
                                .fontWeight(.black)
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 22)
                        .background(Capsule().fill(SparkTheme.Colors.xpElectric))
                        .foregroundColor(.black)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private func briefingSection(title: String, content: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(SparkTheme.Colors.xpElectric)
                Text(title)
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(SparkTheme.Colors.xpElectric)
            }
            
            Text(content.isEmpty ? "Direct objective extraction in progress..." : content)
                .font(SparkTheme.Typography.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
    }
}
