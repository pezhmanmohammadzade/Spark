import SwiftUI
import SwiftData

public struct PhaseGateNavigation: View {
    @Bindable public var project: CBLProject
    @State private var selectedPhase: CBLPhase = .engage
    @Namespace private var animation
    
    @Environment(\.modelContext) private var modelContext
    @Query private var stats: [UserStats]
    
    public init(project: CBLProject) {
        self._project = Bindable(project)
    }
    
    private var currentUserStats: UserStats {
        stats.first ?? UserStats()
    }
    
    public enum CBLPhase: String, CaseIterable, Identifiable {
        case engage = "Spark"
        case investigate = "Deep Dive"
        case act = "Launch"
        
        public var id: String { self.rawValue }
        public var color: Color {
            switch self {
            case .engage: return SparkTheme.Colors.engage
            case .investigate: return SparkTheme.Colors.investigate
            case .act: return SparkTheme.Colors.act
            }
        }
        
        public var icon: String {
            switch self {
            case .engage: return "sparkles"
            case .investigate: return "magnifyingglass.circle.fill"
            case .act: return "target"
            }
        }
        
        public var stepTypes: [String] {
            switch self {
            case .engage: return ["Big Idea", "Essential Question", "Challenge"]
            case .investigate: return ["Guiding Questions", "Guiding Activities", "Guiding Resources", "Synthesis"]
            case .act: return ["Solution Concept", "Implementation", "Reflection"]
            }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                SparkBackground()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                VStack(spacing: 0) {
                    // SPARK HUD (GAMIFICATION LAYER)
                    HStack(spacing: 16) {
                        EvolvingHexagon(level: currentUserStats.level, color: SparkTheme.Colors.levelGold)
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentUserStats.levelTitle.uppercased())
                                .font(SparkTheme.Typography.micro)
                                .foregroundColor(.white.opacity(0.7))
                            
                            ProgressView(value: Double(currentUserStats.currentXP), total: Double(max(currentUserStats.xpForNextLevel, 1)))
                                .tint(SparkTheme.Colors.xpElectric)
                                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(currentUserStats.dailyStreak)")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(SparkTheme.Colors.streakFlame)
                            Text("STREAK")
                                .font(SparkTheme.Typography.micro)
                                .foregroundColor(SparkTheme.Colors.streakFlame.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // HEADER
                    VStack(alignment: .leading, spacing: 12) {
                        Text(project.title.uppercased())
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        ProgressView(value: completionPercentage)
                            .tint(SparkTheme.Colors.xpElectric)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // PHASES
                    HStack(spacing: 30) {
                        ForEach(CBLPhase.allCases) { phase in
                            Button(action: {
                                withAnimation(.spring()) { selectedPhase = phase }
                                HapticManager.shared.triggerSelection()
                            }) {
                                PhaseBadge(phase: phase, isSelected: selectedPhase == phase, progress: project.completionForPhase(types: phase.stepTypes))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.ultraThinMaterial.opacity(0.3))
                    
                    // STEPS
                    ScrollView(showsIndicators: false) {
                        let currentPhaseSteps = stepsForSelectedPhase
                        VStack(spacing: 16) {
                            if project.steps.isEmpty {
                                VStack(spacing: 20) {
                                    Spacer(minLength: 100)
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(SparkTheme.Colors.streakFlame)
                                    
                                    Text("MISSION_DATA_MISSING")
                                        .font(SparkTheme.Typography.cardHeader)
                                        .foregroundColor(.white)
                                    
                                    Button(action: {
                                        project.generateDefaultSteps()
                                        HapticManager.shared.triggerSuccess()
                                    }) {
                                        Text("REGENERATE MISSION MAP")
                                            .font(.caption.bold())
                                            .padding()
                                            .background(Capsule().fill(SparkTheme.Colors.xpElectric))
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(40)
                            } else {
                                ForEach(currentPhaseSteps) { step in
                                    let isLocked = step.order > 0 && !(project.steps.first(where: { $0.order == step.order - 1 })?.isCompleted ?? false)
                                    PremiumStepCardView(step: step, phaseColor: selectedPhase.color, isLocked: isLocked)
                                }
                            }
                            Spacer(minLength: 120)
                        }
                        .padding(24)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Floating Back Button
                VStack {
                    HStack {
                        Button(action: {
                            HapticManager.shared.triggerImpact(0)
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white.opacity(0.8))
                                .shadow(radius: 5)
                        }
                        .padding(.leading, 20)
                        .padding(.top, 15)
                        Spacer()
                    }
                    Spacer()
                }
                
                // Spark AI Advisor
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        SparkCoachButton(project: project, phase: selectedPhase)
                            .padding(.trailing, 20)
                            .padding(.bottom, 30)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea(.keyboard)
        .toolbar(.hidden)
    }
    
    // MARK: - Components
    
    public struct PhaseBadge: View {
        public let phase: CBLPhase
        public let isSelected: Bool
        public let progress: Double
        
        public init(phase: CBLPhase, isSelected: Bool, progress: Double) {
            self.phase = phase
            self.isSelected = isSelected
            self.progress = progress
        }
        
        public var body: some View {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 2)
                        .frame(width: 48, height: 48)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(phase.color, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: 48, height: 48)
                        .rotationEffect(.degrees(-90))
                    
                    Image(systemName: phase == .engage ? "brain.head.profile" : phase.icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.4))
                }
                .scaleEffect(isSelected ? 1.15 : 1.0)
                
                Text(phase.rawValue.uppercased())
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.4))
                    .tracking(1)
            }
        }
    }
    
    private var completionPercentage: Double {
        let completed = project.steps.filter { $0.isCompleted }.count
        return Double(completed) / Double(max(project.steps.count, 1))
    }
    
    private var stepsForSelectedPhase: [CBLStep] {
        let sortedSteps = project.steps.sorted { $0.order < $1.order }
        switch selectedPhase {
        case .engage: return Array(sortedSteps.prefix(3))
        case .investigate: return Array(sortedSteps.dropFirst(3).prefix(4))
        case .act: return Array(sortedSteps.dropFirst(7))
        }
    }
}

public struct PremiumStepCardView: View {
    public let step: CBLStep
    public let phaseColor: Color
    public let isLocked: Bool
    @State private var isPressed = false
    
    public init(step: CBLStep, phaseColor: Color, isLocked: Bool) {
        self.step = step
        self.phaseColor = phaseColor
        self.isLocked = isLocked
    }
    
    public var body: some View {
        NavigationLink(destination: StepDetailView(step: step)) {
            GlassCard {
                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(phaseColor.opacity(isLocked ? 0.1 : 0.4), lineWidth: 1)
                            .frame(width: 40, height: 40)
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.3))
                        } else {
                            Text("\(step.order + 1)")
                                .font(SparkTheme.Typography.micro)
                                .foregroundColor(phaseColor)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(step.type.capitalized)
                                .font(SparkTheme.Typography.cardHeader)
                                .foregroundColor(isLocked ? .white.opacity(0.3) : .white)
                            Spacer()
                            if !step.isCompleted && !isLocked {
                                Text("\(step.xpValue) XP")
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(SparkTheme.Colors.levelGold)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(SparkTheme.Colors.levelGold.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                        
                        Text(step.content.isEmpty ? (isLocked ? "Complete previous steps" : "Required input for Phase Completion") : step.content)
                            .font(SparkTheme.Typography.body)
                            .foregroundColor(.white.opacity(0.4))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    if !isLocked {
                        Image(systemName: step.isCompleted ? "checkmark.circle.fill" : "arrow.right.circle")
                            .font(.title2)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(step.isCompleted ? phaseColor : .white.opacity(0.3))
                    }
                }
            }
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(), value: isPressed)
        }
        .buttonStyle(.plain)
        .disabled(isLocked)
        .onLongPressGesture(pressing: { pressing in isPressed = pressing }, perform: {})
    }
}

public struct SparkCoachButton: View {
    public let project: CBLProject
    public let phase: PhaseGateNavigation.CBLPhase
    @State private var showConsultation = false
    @State private var isPulsing = false
    
    public init(project: CBLProject, phase: PhaseGateNavigation.CBLPhase) {
        self.project = project
        self.phase = phase
    }
    
    public var body: some View {
        Button(action: {
            HapticManager.shared.triggerImpact(2)
            showConsultation = true
        }) {
            ZStack {
                Circle()
                    .fill(SparkTheme.Colors.xpElectric.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .scaleEffect(isPulsing ? 1.4 : 1.0)
                    .opacity(isPulsing ? 0 : 0.6)
                
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Circle()
                            .stroke(SparkTheme.Colors.xpElectric.opacity(0.5), lineWidth: 1)
                    )
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(SparkTheme.Colors.xpElectric)
                    .symbolEffect(.pulse, value: isPulsing)
            }
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false)) {
                isPulsing = true
            }
        }
        .sheet(isPresented: $showConsultation) {
            SparkConsultationView(project: project, phase: phase.rawValue)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

public struct SparkConsultationView: View {
    public let project: CBLProject
    public let phase: String
    @Environment(\.dismiss) private var dismiss
    
    public init(project: CBLProject, phase: String) {
        self.project = project
        self.phase = phase
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            SparkBackground().opacity(0.3)
            
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Image(systemName: "bolt.shield.fill")
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                    Text("SPARK_CONSULTATION")
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(2)
                    Spacer()
                    Button("CLOSE") { dismiss() }
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PHASE_TACTICAL_MODE: \(phase.uppercased())")
                                .font(.caption.bold())
                                .foregroundColor(SparkTheme.Colors.xpElectric)
                            
                            Text(AIService.shared.getPhaseGuidance(phase: phase))
                                .font(SparkTheme.Typography.body)
                                .foregroundColor(.white)
                                .lineSpacing(4)
                        }
                        
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(SparkTheme.Colors.streakFlame)
                                    Text("ACTIVE_CHALLENGE")
                                        .font(SparkTheme.Typography.micro)
                                        .foregroundColor(SparkTheme.Colors.streakFlame)
                                }
                                
                                Text(AIService.shared.generateProactiveChallenge(project: project))
                                    .font(SparkTheme.Typography.cardHeader)
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}
