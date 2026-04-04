import SwiftUI
import SwiftData
import Foundation

// MARK: - Workshop Schedule Section

public struct WorkshopScheduleSection: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workshop.scheduledDate) private var workshops: [Workshop]
    @State private var selectedWorkshop: Workshop?
    @State private var showArchive: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundColor(SparkTheme.Colors.xpElectric)
                        Text("UPCOMING_WORKSHOPS")
                            .font(SparkTheme.Typography.micro)
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(2)
                    }
                    Text("LEVEL-UP YOUR STARTUP")
                        .font(SparkTheme.Typography.title(size: 18))
                        .foregroundColor(.white)
                }
                Spacer()
                
                Button("VIEW ALL") {
                    HapticManager.shared.triggerSelection()
                    showArchive = true
                }
                .font(SparkTheme.Typography.micro)
                .foregroundColor(SparkTheme.Colors.xpElectric)
            }
            .padding(.horizontal, 20)
            
            // Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(workshops) { workshop in
                        Button(action: {
                            HapticManager.shared.triggerSelection()
                            selectedWorkshop = workshop
                        }) {
                            WorkshopCard(workshop: workshop)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // "Locked" or Placeholder card for intrigue
                    UpcomingPlaceholderCard()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }
        .onAppear {
            seedWorkshopsIfNeeded()
        }
        .fullScreenCover(item: $selectedWorkshop) { workshop in
            WorkshopPortalView(workshop: workshop)
        }
        .fullScreenCover(isPresented: $showArchive) {
            WorkshopArchiveView()
        }
    }
    
    private func seedWorkshopsIfNeeded() {
        let seeds = Workshop.seedWorkshops
        for seed in seeds {
            let title = seed.title
            let descriptor = FetchDescriptor<Workshop>(predicate: #Predicate { $0.title == title })
            if let existing = try? modelContext.fetch(descriptor), existing.isEmpty {
                modelContext.insert(seed)
            }
        }
        try? modelContext.save()
    }
}

// MARK: - Workshop Card

public struct WorkshopCard: View {
    let workshop: Workshop
    
    public init(workshop: Workshop) {
        self.workshop = workshop
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header: Topic & Status
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: workshop.topicIcon)
                        .font(.caption2.bold())
                    Text(workshop.topic.uppercased())
                        .font(SparkTheme.Typography.micro)
                }
                .foregroundColor(topicColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(topicColor.opacity(0.15))
                .clipShape(Capsule())
                
                Spacer()
                
                statusBadge
            }
            
            // Title & Description
            VStack(alignment: .leading, spacing: 8) {
                Text(workshop.title)
                    .font(SparkTheme.Typography.title(size: 20))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(workshop.workshopDescription)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)
            }
            
            Spacer(minLength: 0)
            
            // Footer: Time & XP
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("SCHEDULED")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white.opacity(0.4))
                    Text(formatDate(workshop.scheduledDate))
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                    Text("+\(workshop.xpValue) XP")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                }
            }
        }
        .padding(20)
        .frame(width: 260, height: 180)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(.ultraThinMaterial)
                
                // Subtle Gradient Glow
                RoundedRectangle(cornerRadius: 32)
                    .stroke(
                        LinearGradient(
                            colors: [topicColor.opacity(0.5), .clear, .clear, topicColor.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .shadow(color: topicColor.opacity(0.1), radius: 15, x: 0, y: 10)
    }
    
    private var statusBadge: some View {
        let isLive = workshop.scheduledDate <= Date() && !workshop.isCompleted
        
        return HStack(spacing: 4) {
            if isLive {
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
                    .symbolEffect(.pulse)
                Text("LIVE")
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(.white)
            } else if workshop.isCompleted {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 10))
                    .foregroundColor(SparkTheme.Colors.act)
                Text("PASSED")
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(SparkTheme.Colors.act)
            } else {
                Text("UPCOMING")
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isLive ? Color.red.opacity(0.2) : Color.white.opacity(0.05))
        .cornerRadius(6)
    }
    
    private var topicColor: Color {
        switch workshop.topic.lowercased() {
        case "marketing": return .purple
        case "storytelling": return .orange
        case "app dev": return .blue
        default: return SparkTheme.Colors.xpElectric
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return "TODAY @ \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = "MMM d, HH:mm"
            return formatter.string(from: date).uppercased()
        }
    }
}

public struct UpcomingPlaceholderCard: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .font(.title2)
                .foregroundColor(.white.opacity(0.1))
            Text("DATA_SYNCING...")
                .font(SparkTheme.Typography.micro)
                .foregroundColor(.white.opacity(0.1))
        }
        .frame(width: 140, height: 180)
        .background(RoundedRectangle(cornerRadius: 32).stroke(Color.white.opacity(0.05), style: StrokeStyle(lineWidth: 1, dash: [5])))
    }
}

// MARK: - Workshop Portal View

public struct WorkshopPortalView: View {
    let workshop: Workshop
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var stats: [UserStats]
    
    @State private var phase: WorkshopPhase = .intro
    @State private var transmissionIndex: Int = 0
    @State private var userInput: String = ""
    @State private var isAnalyzing: Bool = false
    @State private var feedback: String = ""
    @State private var showSuccess: Bool = false
    @State private var isError: Bool = false
    
    public init(workshop: Workshop) {
        self.workshop = workshop
    }
    
    public enum WorkshopPhase {
        case intro, transmission, challenge, result
    }
    
    public var body: some View {
        ZStack {
            SparkBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                header
                
                ScrollView {
                    VStack(spacing: 20) {
                        contentBody
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                actionButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
            }
        }
        .overlay {
            if showSuccess {
                SuccessOverlay(xp: workshop.xpValue) {
                    finalizeCompletion()
                }
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.3))
                }
                Spacer()
                Text(workshop.topic.uppercased())
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(SparkTheme.Colors.xpElectric)
                    .tracking(2)
                Spacer()
                Image(systemName: "brain.head.profile")
                    .foregroundColor(SparkTheme.Colors.xpElectric)
                    .symbolEffect(.pulse)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            
            Text(workshop.title)
                .font(SparkTheme.Typography.title(size: 24))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    private var contentBody: some View {
        switch phase {
        case .intro:
            VStack(alignment: .leading, spacing: 20) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SPARK INSTRUCTOR: \(workshop.instructorAI)")
                            .font(SparkTheme.Typography.micro)
                            .foregroundColor(SparkTheme.Colors.xpElectric)
                        
                        Text(workshop.workshopDescription)
                            .font(SparkTheme.Typography.body)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("LEARNING OUTCOME")
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(.white.opacity(0.5))
                    Text(workshop.learningOutcome)
                        .font(.headline)
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                }
                .padding(.top, 10)
            }
            .transition(.move(edge: .trailing).combined(with: .opacity))
            
        case .transmission:
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("TRANSMISSION \(transmissionIndex + 1)/\(workshop.guidingCoreSteps.count)")
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                    Spacer()
                    ProgressView(value: Double(transmissionIndex + 1), total: Double(workshop.guidingCoreSteps.count))
                        .tint(SparkTheme.Colors.xpElectric)
                        .frame(width: 80)
                }
                
                let stepContent = workshop.guidingCoreSteps[transmissionIndex]
                
                if stepContent.contains("TEACHING:") {
                    TeachingTransmissionView(content: stepContent)
                        .id("teaching_\(transmissionIndex)")
                } else if stepContent.contains("TACTIC:") {
                    TacticTransmissionView(content: stepContent)
                        .id("tactic_\(transmissionIndex)")
                } else if stepContent.contains("CORE:") {
                    CoreTransmissionView(content: stepContent)
                        .id("core_\(transmissionIndex)")
                } else {
                    DefaultTransmissionView(content: stepContent)
                        .id("default_\(transmissionIndex)")
                }
            }
            
        case .challenge:
            VStack(alignment: .leading, spacing: 20) {
                Text("TACTICAL CHALLENGE")
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(SparkTheme.Colors.xpElectric)
                
                Text(getDynamicChallenge())
                    .font(.headline)
                    .foregroundColor(.white)
                
                TextField("Input your strategic architecture...", text: $userInput, axis: .vertical)
                    .font(SparkTheme.Typography.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                    .lineLimit(6...12)
                
                if isAnalyzing {
                    HStack {
                        ProgressView()
                            .tint(SparkTheme.Colors.xpElectric)
                        Text("NEXUS IS PERFORMING DEEP SCAN...")
                            .font(SparkTheme.Typography.micro)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
            .transition(.move(edge: .trailing).combined(with: .opacity))
            
        case .result:
            VStack(alignment: .leading, spacing: 20) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: isError ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                                .foregroundColor(isError ? .orange : SparkTheme.Colors.act)
                            Text(isError ? "EVOLUTION_REJECTED" : "EVOLUTION_VALIDATED")
                                .font(SparkTheme.Typography.micro)
                                .foregroundColor(isError ? .orange : SparkTheme.Colors.act)
                        }
                        
                        Text(feedback)
                            .font(SparkTheme.Typography.body)
                            .foregroundColor(.white)
                    }
                }
                
                if isError {
                    Button(action: { 
                        withAnimation {
                            phase = .challenge
                            isError = false
                        }
                    }) {
                        Text("RE-EVOLVE STRATEGY")
                            .font(.headline.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Capsule().fill(Color.white))
                    }
                    .padding(.top, 20)
                }
                
                if !workshop.masteryBadge.isEmpty && !isError {
                    MasteryUnlockCard(badge: workshop.masteryBadge)
                        .padding(.top, 20)
                }
            }
            .transition(.scale.combined(with: .opacity))
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
        .disabled(phase == .challenge && userInput.isEmpty)
        .opacity(phase == .challenge && userInput.isEmpty ? 0.6 : 1.0)
    }
    
    private var buttonLabel: String {
        switch phase {
        case .intro: return "BEGIN TRANSMISSION"
        case .transmission: 
            return transmissionIndex == workshop.guidingCoreSteps.count - 1 ? "READY FOR CHALLENGE" : "NEXT TRANSMISSION"
        case .challenge: return isAnalyzing ? "ANALYZING..." : "SUBMIT ARCHITECTURE"
        case .result: return isError ? "EVOLUTION FAILED" : "CLAIM \(workshop.xpValue) XP"
        }
    }
    
    private var buttonIcon: String {
        switch phase {
        case .intro: return "antenna.radiowaves.left.and.right"
        case .transmission: return "arrow.right"
        case .challenge: return "paperplane.fill"
        case .result: return isError ? "exclamationmark.shield.fill" : "sparkles"
        }
    }
    
    private var buttonColor: Color {
        if isError && phase == .result { return .orange.opacity(0.6) }
        switch phase {
        case .intro, .transmission: return SparkTheme.Colors.xpElectric
        case .challenge: return .blue
        case .result: return SparkTheme.Colors.act
        }
    }
    
    private func handleAction() {
        HapticManager.shared.triggerSelection()
        
        switch phase {
        case .intro:
            withAnimation { phase = .transmission }
        case .transmission:
            if transmissionIndex < workshop.guidingCoreSteps.count - 1 {
                withAnimation { transmissionIndex += 1 }
            } else {
                withAnimation { phase = .challenge }
            }
        case .challenge:
            triggerAnalysis()
        case .result:
            if !isError {
                withAnimation { showSuccess = true }
            }
        }
    }
    
    private func triggerAnalysis() {
        isAnalyzing = true
        Task {
            let result = await AIService.shared.validateWorkshopResponse(
                topic: workshop.topic,
                title: workshop.title,
                response: userInput,
                keywords: workshop.aiValidationKeywords,
                minWords: workshop.minimumWordCount
            )
            await MainActor.run {
                feedback = result.feedback
                isError = !result.isValid
                if isError {
                    HapticManager.shared.triggerError()
                } else {
                    HapticManager.shared.triggerSuccess()
                }
                withAnimation {
                    isAnalyzing = false
                    phase = .result
                }
            }
        }
    }
    
    private func finalizeCompletion() {
        workshop.isCompleted = true
        let userStats = stats.first ?? UserStats()
        userStats.addXP(workshop.xpValue)
        try? modelContext.save()
        HapticManager.shared.triggerSuccess()
        dismiss()
    }
    
    private func getDynamicChallenge() -> String {
        switch workshop.topic.lowercased() {
        case "strategy": return "Identify the 'wedge' you would use to disrupt a dominant incumbent. What specific cognitive friction do they ignore?"
        case "growth": return "Engineer your core referral loop. How does a user's action naturally recruit the next participant in your ecosystem?"
        case "finance": return "If your CAC doubled tomorrow, how would your LTV architecture adapt to maintain metabolic sustainability?"
        case "psychology": return "What is the primary 'Trigger' in your product that aligns with existing user neural habits and reward systems?"
        case "marketing": return "Define the recursive narrative loop of your brand. What specific story do your users tell their peers after the first interaction?"
        default: return "Identify the primary cognitive gap in your segment and propose a tactical bridge to resolve it."
        }
    }
}

// MARK: - Workshop Archive View

public struct WorkshopArchiveView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workshop.scheduledDate) private var workshops: [Workshop]
    @State private var selectedWorkshop: Workshop?
    
    public init() {}
    
    private var upcomingWorkshops: [Workshop] {
        workshops.filter { !$0.isCompleted }
    }
    
    private var masteredWorkshops: [Workshop] {
        workshops.filter { $0.isCompleted }
    }
    
    public var body: some View {
        ZStack {
            SparkBackground()
                .ignoresSafeArea()
            
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
                    }
                    
                    Spacer()
                    
                    Text("WORKSHOP ARCHIVE")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(2)
                    
                    Spacer()
                    
                    Text("\(workshops.count) TOPICS")
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        // Section: Upcoming
                        if !upcomingWorkshops.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("UPCOMING_TRANSMISSIONS")
                                    .font(SparkTheme.Typography.micro)
                                    .foregroundColor(SparkTheme.Colors.xpElectric)
                                
                                ForEach(upcomingWorkshops) { workshop in
                                    Button(action: {
                                        HapticManager.shared.triggerSelection()
                                        selectedWorkshop = workshop
                                    }) {
                                        WorkshopCard(workshop: workshop)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        // Section: Mastered
                        if !masteredWorkshops.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("MASTERED_TOPICS")
                                    .font(SparkTheme.Typography.micro)
                                    .foregroundColor(SparkTheme.Colors.act)
                                
                                ForEach(masteredWorkshops) { workshop in
                                    Button(action: {
                                        HapticManager.shared.triggerSelection()
                                        selectedWorkshop = workshop
                                    }) {
                                        WorkshopCard(workshop: workshop)
                                    }
                                    .buttonStyle(.plain)
                                    .opacity(0.8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            seedWorkshopsIfNeeded()
        }
        .fullScreenCover(item: $selectedWorkshop) { workshop in
            WorkshopPortalView(workshop: workshop)
        }
    }
    
    private func seedWorkshopsIfNeeded() {
        let seeds = Workshop.seedWorkshops
        for seed in seeds {
            let title = seed.title
            let descriptor = FetchDescriptor<Workshop>(predicate: #Predicate { $0.title == title })
            if let existing = try? modelContext.fetch(descriptor), existing.isEmpty {
                modelContext.insert(seed)
            }
        }
        try? modelContext.save()
    }
}

// MARK: - Interactive Transmission Views

struct TeachingTransmissionView: View {
    let content: String
    @State private var visibleText: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                    Text("SPARK_TEACHING")
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                }
                
                Text(visibleText)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineSpacing(6)
            }
            .padding(.top, 40)
        }
        .onAppear {
            animateText()
        }
    }
    
    private func animateText() {
        let full = content.replacingOccurrences(of: "TEACHING:", with: "").trimmingCharacters(in: .whitespaces)
        var current = ""
        _ = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if current.count < full.count {
                let index = full.index(full.startIndex, offsetBy: current.count)
                current.append(full[index])
                visibleText = current
            } else {
                timer.invalidate()
            }
        }
    }
}

struct TacticTransmissionView: View {
    let content: String
    @State private var isRevealed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "hammer.fill")
                    .foregroundColor(.orange)
                Text("TACTICAL_MOVE")
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(.orange)
            }
            
            Text("TAP TO REVEAL STRATEGY")
                .font(SparkTheme.Typography.body)
                .foregroundColor(.white.opacity(0.4))
                .italic()
            
            Button(action: { 
                withAnimation(.spring()) { isRevealed.toggle() }
                HapticManager.shared.triggerSelection()
            }) {
                GlassCard {
                    Text(content.replacingOccurrences(of: "TACTIC:", with: "").trimmingCharacters(in: .whitespaces))
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .blur(radius: isRevealed ? 0 : 12)
                        .scaleEffect(isRevealed ? 1 : 0.95)
                        .overlay {
                            if !isRevealed {
                                Image(systemName: "eye.slash.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white.opacity(0.3))
                            }
                        }
                }
            }
            .buttonStyle(.plain)
            
            if isRevealed {
                Text("DEPLOY THIS TACTIC IMMEDIATELY TO ACCELERATE EVOLUTION.")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(SparkTheme.Colors.act)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.top, 40)
    }
}

struct CoreTransmissionView: View {
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Image(systemName: "shield.fill")
                    .foregroundColor(SparkTheme.Colors.act)
                Text("THE_CORE_TRUTH")
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(SparkTheme.Colors.act)
            }
            
            Text(content.replacingOccurrences(of: "CORE:", with: "").trimmingCharacters(in: .whitespaces))
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .padding(30)
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(SparkTheme.Colors.act.opacity(0.1))
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(SparkTheme.Colors.act.opacity(0.3), lineWidth: 2)
                        }
                }
                .symbolEffect(.pulse)
        }
        .padding(.top, 40)
    }
}

struct DefaultTransmissionView: View {
    let content: String
    var body: some View {
        Text(content)
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.top, 40)
    }
}

struct MasteryUnlockCard: View {
    let badge: String
    
    var body: some View {
        GlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "trophy.fill")
                    Text("MASTERY_UNLOCKED")
                }
                .font(SparkTheme.Typography.micro)
                .foregroundColor(SparkTheme.Colors.levelGold)
                
                Text(badge.replacingOccurrences(of: "_", with: " "))
                    .font(SparkTheme.Typography.title(size: 20))
                    .foregroundColor(.white)
                
                Text("SKILL REGISTERED IN NEXUS ARCHIVE")
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(.white.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
    }
}

public struct SuccessOverlay: View {
    let xp: Int
    var onComplete: () -> Void
    
    public init(xp: Int, onComplete: @escaping () -> Void) {
        self.xp = xp
        self.onComplete = onComplete
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundColor(SparkTheme.Colors.xpElectric)
                    .symbolEffect(.pulse)
                
                VStack(spacing: 8) {
                    Text("WORKSHOP PASSED")
                        .font(SparkTheme.Typography.title(size: 32))
                        .foregroundColor(.white)
                    Text("YOU HAVE EVOLVED")
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                    Text("+\(xp) XP")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundColor(SparkTheme.Colors.xpElectric)
                }
                
                Button(action: onComplete) {
                    Text("CONTINUE EVOLUTION")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Capsule().fill(Color.white))
                }
                .padding(.horizontal, 40)
            }
        }
    }
}
