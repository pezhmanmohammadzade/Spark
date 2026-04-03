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
    
    public init(step: CBLStep) {
        self.step = step
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                SparkBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    header
                    
                    if !showingFeedback && !isAnalyzing {
                        inputPhase
                    } else if isAnalyzing {
                        analysisPhase
                    } else {
                        evaluationPhase
                    }
                    
                    Spacer()
                    
                    actionButton
                }
                .padding(.horizontal, 24)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("MISSION STEP \(step.order + 1)")
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(SparkTheme.Colors.xpElectric)
                    .tracking(3)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.3))
                }
            }
            
            Text(step.type.uppercased())
                .font(SparkTheme.Typography.title(size: 32))
                .foregroundColor(.white)
        }
        .padding(.top, 40)
    }
    
    private var inputPhase: some View {
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
    
    private var analysisPhase: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle().stroke(Color.white.opacity(0.1), lineWidth: 4)
                Circle().trim(from: 0, to: 0.6).stroke(SparkTheme.Colors.xpElectric, lineWidth: 4)
                    .rotationEffect(.degrees(isAnalyzing ? 360 : 0))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: isAnalyzing)
                
                Image(systemName: "brain.head.profile").font(.largeTitle).foregroundColor(.white)
            }
            .frame(width: 100, height: 100)
            
            Text("SPARK IS ANALYZING...")
                .font(SparkTheme.Typography.micro)
                .tracking(2)
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    private var evaluationPhase: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle().stroke(Color.white.opacity(0.1), lineWidth: 8)
                Circle().trim(from: 0, to: currentScore).stroke(scoreColor, lineWidth: 8)
                
                VStack(spacing: 0) {
                    Text("\(Int(currentScore * 100))")
                        .font(.system(size: 44, weight: .black, design: .rounded))
                    Text("%")
                        .font(.caption).bold()
                }
                .foregroundColor(.white)
            }
            .frame(width: 140, height: 140)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    feedbackSection(title: "INSIGHT", content: currentFeedback.insight, icon: "eye.fill", color: SparkTheme.Colors.xpElectric)
                    feedbackSection(title: "CHALLENGE", content: currentFeedback.challenge, icon: "bolt.fill", color: SparkTheme.Colors.streakFlame)
                    
                    if !currentFeedback.guidingQuestions.isEmpty {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "questionmark.circle.fill")
                                    Text("GUIDING QUESTIONS")
                                        .font(SparkTheme.Typography.micro)
                                }
                                .foregroundColor(SparkTheme.Colors.levelGold)
                                
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
                    Text(title)
                        .font(SparkTheme.Typography.micro)
                }
                .foregroundColor(color)
                
                Text(content)
                    .font(SparkTheme.Typography.body)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
    }
    
    private var actionButton: some View {
        Button(action: handleAction) {
            HStack {
                Text(buttonLabel)
                    .fontWeight(.black)
                Spacer()
                Image(systemName: buttonIcon)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 22)
            .background(Capsule().fill(buttonColor))
            .foregroundColor(.white)
        }
        .disabled(!showingFeedback && inputContent.isEmpty)
        .opacity(inputContent.isEmpty && !showingFeedback ? 0.6 : 1.0)
        .padding(.bottom, 20)
    }
    
    private var scoreColor: Color {
        currentScore >= 0.7 ? SparkTheme.Colors.act : SparkTheme.Colors.streakFlame
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
        return scoreColor
    }
    
    private func handleAction() {
        if !showingFeedback {
            triggerEvaluation()
        } else if currentScore >= 0.7 {
            finalizeCompletion()
        } else {
            withAnimation { showingFeedback = false }
        }
    }
    
    private func triggerEvaluation() {
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
        
        let stats = stats.first ?? UserStats()
        stats.addXP(step.xpValue)
        
        try? modelContext.save()
        HapticManager.shared.triggerSuccess()
        dismiss()
    }
}
