import SwiftUI
import SwiftData

public struct StepDetailView: View {
    @Bindable public var step: CBLStep
    @Query private var stats: [UserStats]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var inputContent: String = ""
    @State private var isAnalyzing = false
    @State private var showingFeedback = false
    @State private var currentScore: Double = 0.0
    @State private var currentFeedback = StepFeedback()
    @State private var showConsentSheet: Bool = false
    
    // Reactive UI state
    @State private var accentOverride: Color?
    @State private var showXPToast = false
    @State private var xpToastAmount: Int = 0
    @State private var xpToastCritical = false
    @State private var xpToastMultiplier: Double = 1.0
    @State private var scoreShake = false
    
    // Analysis animation
    @State private var analysisMessages: [String] = []
    private let analysisTerminalLines = [
        "PARSING COGNITIVE INPUT...",
        "EVALUATING STRATEGIC DEPTH...",
        "SCANNING FOR PARADOXES...",
        "COMPUTING NEURAL ALIGNMENT...",
        "GENERATING BRUTAL FEEDBACK..."
    ]
    
    public init(step: CBLStep) {
        self.step = step
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            SparkBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header.padding(.horizontal, 24)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        if !showingFeedback && !isAnalyzing {
                            inputPhase
                        } else if isAnalyzing {
                            analysisPhase.padding(.top, 60)
                        } else {
                            evaluationPhase
                        }
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                }
            }
            
            actionButton
                .padding(.horizontal, 24)
            
            // XP Toast Overlay
            if showXPToast {
                xpToastView
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(10)
            }
        }
        .onTapGesture { hideKeyboard() }
        .sheet(isPresented: $showConsentSheet) {
            AIConsentView(
                onContinue: { triggerEvaluation() },
                onCancel: { }
            )
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Header
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text("MISSION STEP \(step.order + 1)")
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(accentOverride ?? SparkTheme.Colors.xpElectric)
                    .tracking(3)
                
                Spacer()
                
                Button(action: {
                    HapticManager.shared.triggerSelection()
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(12)
                        .contentShape(Circle())
                }
                .offset(x: 12)
            }
            .padding(.top, 16)
            
            Text(step.type.uppercased())
                .font(SparkTheme.Typography.title(size: 32))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Input Phase
    
    private var inputPhase: some View {
        VStack(spacing: 24) {
            guidingCoreSection
            
            GlassCard {
                VStack(alignment: .leading, spacing: 20) {
                    Text(AIService.shared.generateSocraticQuestion(for: step.type))
                        .font(.headline)
                        .italic()
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                    
                    TextField("Input your evolution here...", text: $inputContent, axis: .vertical)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.05)))
                        .lineLimit(5...10)
                }
            }
        }
    }
    
    private var guidingCoreSection: some View {
        let guide = CBLGuideService.shared.guide(for: step.type)
        return GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: guide.icon)
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                    Text("SPARK GUIDING CORE: \(guide.title)")
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(guide.definition)
                        .font(SparkTheme.Typography.body)
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "bullseye")
                            .foregroundColor(SparkTheme.Colors.act)
                            .font(.caption)
                        Text(guide.strategicGoal)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("SUCCESS_CRITERIA:")
                            .font(.system(size: 8, weight: .black))
                            .foregroundColor(.white.opacity(0.4))
                        
                        ForEach(guide.successCriteria, id: \.self) { criteria in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•").foregroundColor(SparkTheme.Colors.act)
                                Text(criteria)
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.shield.fill")
                            .foregroundColor(SparkTheme.Colors.streakFlame)
                            .font(.caption)
                        Text(guide.pitfall)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(SparkTheme.Colors.streakFlame)
                    }
                    .padding(10)
                    .background(SparkTheme.Colors.streakFlame.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - Analysis Phase (Enhanced)
    
    private var analysisPhase: some View {
        VStack(spacing: 30) {
            ZStack {
                // Pulsing rings
                PulsingRingView(color: SparkTheme.Colors.xpElectric, baseSize: 80)
                
                // 3D Orb instead of plain spinner
                Spark3DOrb(size: 80, color: SparkTheme.Colors.xpElectric)
                    .shadow(color: SparkTheme.Colors.xpElectric.opacity(0.5), radius: 20)
                
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(.white)
                    .shadow(radius: 4)
            }
            .frame(width: 120, height: 120)
            
            Text("SPARK IS ANALYZING...")
                .font(SparkTheme.Typography.micro)
                .tracking(2)
                .foregroundColor(.white.opacity(0.6))
            
            // Terminal-style analysis messages
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(analysisMessages.enumerated()), id: \.offset) { _, msg in
                    HStack(spacing: 6) {
                        Circle().fill(SparkTheme.Colors.xpElectric).frame(width: 4, height: 4)
                        Text(msg)
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(SparkTheme.Colors.xpElectric.opacity(0.8))
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
        }
        .onAppear { runAnalysisTerminal() }
    }
    
    private func runAnalysisTerminal() {
        analysisMessages = []
        for i in 0..<analysisTerminalLines.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.7) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    analysisMessages.append(analysisTerminalLines[i])
                }
                HapticManager.shared.triggerImpact(0)
            }
        }
    }
    
    // MARK: - Evaluation Phase (Reactive)
    
    private var evaluationPhase: some View {
        VStack(spacing: 24) {
            // Score-reactive indicator
            if currentScore >= 0.85 {
                Text("⚡ CRITICAL HIT")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundColor(SparkTheme.Colors.criticalHit)
                    .tracking(3)
                    .shadow(color: SparkTheme.Colors.criticalHit.opacity(0.5), radius: 8)
            }
            
            ZStack {
                Circle().stroke(Color.white.opacity(0.1), lineWidth: 8)
                Circle().trim(from: 0, to: currentScore)
                    .stroke(reactiveScoreColor, lineWidth: 8)
                
                VStack(spacing: 0) {
                    Text("\(Int(currentScore * 100))")
                        .font(.system(size: 44, weight: .black, design: .rounded))
                    Text("%").font(.caption).bold()
                }
                .foregroundColor(.white)
            }
            .frame(width: 140, height: 140)
            .offset(x: scoreShake ? -8 : 0)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    feedbackSection(title: "INSIGHT", content: currentFeedback.insight, icon: "eye.fill", color: reactiveScoreColor)
                    feedbackSection(title: "CHALLENGE", content: currentFeedback.challenge, icon: "bolt.fill", color: SparkTheme.Colors.streakFlame)
                    
                    if !currentFeedback.guidingQuestions.isEmpty {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "questionmark.circle.fill")
                                    Text("GUIDING QUESTIONS").font(SparkTheme.Typography.micro)
                                }.foregroundColor(SparkTheme.Colors.levelGold)
                                
                                ForEach(currentFeedback.guidingQuestions, id: \.self) { question in
                                    Text("• \(question)")
                                        .font(SparkTheme.Typography.body)
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(.leading, 8)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                    
                    if let suggestion = currentFeedback.suggestion {
                        feedbackSection(title: "SUGGESTION", content: suggestion, icon: "lightbulb.fill", color: SparkTheme.Colors.act)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    private func feedbackSection(title: String, content: String, icon: String, color: Color) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                    Text(title).font(SparkTheme.Typography.micro)
                }.foregroundColor(color)
                
                Text(content)
                    .font(SparkTheme.Typography.body)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
    }
    
    // MARK: - Reactive Score Color
    
    private var reactiveScoreColor: Color {
        if currentScore >= 0.85 { return SparkTheme.Colors.criticalHit }
        if currentScore >= 0.7 { return SparkTheme.Colors.act }
        if currentScore >= 0.4 { return SparkTheme.Colors.streakFlame }
        return SparkTheme.Colors.harshFail
    }
    
    // MARK: - XP Toast
    
    private var xpToastView: some View {
        VStack(spacing: 6) {
            if xpToastCritical {
                Text("⚡ CRITICAL HIT")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundColor(SparkTheme.Colors.criticalHit)
            }
            
            Text("+\(xpToastAmount) XP")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: reactiveScoreColor.opacity(0.6), radius: 12)
            
            if xpToastMultiplier > 1.0 {
                Text("x\(String(format: "%.1f", xpToastMultiplier)) STREAK")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(SparkTheme.Colors.xpElectric)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(SparkTheme.Colors.xpElectric.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(32)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.3), radius: 20)
    }
    
    // MARK: - Action Button
    
    private var actionButton: some View {
        Button(action: handleAction) {
            HStack {
                Text(buttonLabel).fontWeight(.black)
                Spacer()
                Image(systemName: buttonIcon)
            }
            .padding(.horizontal, 30).padding(.vertical, 22)
            .background(Capsule().fill(buttonColor))
            .foregroundColor(.white)
        }
        .disabled(!showingFeedback && inputContent.isEmpty)
        .opacity(inputContent.isEmpty && !showingFeedback ? 0.6 : 1.0)
        .padding(.bottom, 20)
    }
    
    private var buttonLabel: String {
        if !showingFeedback { return "SUBMIT TO SPARK" }
        return currentScore >= 0.7 ? "CLEAR GATE" : "RE-EVOLVE"
    }
    
    private var buttonIcon: String {
        if !showingFeedback { return "paperplane.fill" }
        return currentScore >= 0.7 ? "checkmark.seal.fill" : "arrow.clockwise"
    }
    
    private var buttonColor: Color {
        if !showingFeedback { return SparkTheme.Colors.xpElectric }
        return reactiveScoreColor
    }
    
    // MARK: - Actions
    
    private func handleAction() {
        if !showingFeedback {
            triggerEvaluation()
        } else if currentScore >= 0.7 {
            finalizeCompletion()
        } else {
            withAnimation { showingFeedback = false; accentOverride = nil }
        }
    }
    
    private func triggerEvaluation() {
        if !AIConsentManager.shared.hasGrantedConsent {
            showConsentSheet = true
            return
        }
        
        isAnalyzing = true
        let previous = step.content.isEmpty ? nil : step.content
        Task {
            let result = await AIService.shared.evaluateStep(content: inputContent, type: step.type, previousContent: previous)
            await MainActor.run {
                withAnimation {
                    isAnalyzing = false
                    currentScore = result.0
                    currentFeedback = result.1
                    showingFeedback = true
                    accentOverride = reactiveScoreColor
                }
                
                // Score-reactive haptics
                if currentScore < 0.4 {
                    HapticManager.shared.triggerError()
                    withAnimation(.default.repeatCount(3, autoreverses: true).speed(6)) {
                        scoreShake = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { scoreShake = false }
                } else if currentScore >= 0.85 {
                    HapticManager.shared.triggerSuccess()
                }
            }
        }
    }
    
    private func finalizeCompletion() {
        step.isCompleted = true
        step.evaluationScore = currentScore
        step.aiInsight = currentFeedback.insight
        step.aiChallenge = currentFeedback.challenge
        step.aiGuidingQuestions = currentFeedback.guidingQuestions
        step.aiSuggestion = currentFeedback.suggestion ?? ""
        step.content = inputContent
        
        let userStats = stats.first ?? UserStats()
        
        // Quality-based XP with streak multiplier
        let result = GamificationService.shared.awardQualityXP(
            baseXP: step.xpValue,
            score: currentScore,
            to: userStats,
            modelContext: modelContext
        )
        
        // Show XP toast
        xpToastAmount = result.xpAwarded
        xpToastCritical = result.isCriticalHit
        xpToastMultiplier = userStats.streakMultiplier
        
        try? modelContext.save()
        HapticManager.shared.triggerSuccess()
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { showXPToast = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation { showXPToast = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { dismiss() }
        }
    }
}
