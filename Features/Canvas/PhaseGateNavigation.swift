import SwiftUI

struct PhaseGateNavigation: View {
    @Bindable var project: CBLProject
    @State private var selectedPhase: CBLPhase = .engage
    @Namespace private var animation // For sliding capsule
    
    enum CBLPhase: String, CaseIterable, Identifiable {
        case engage = "Spark"
        case investigate = "Deep Dive"
        case act = "Launch"
        
        var id: String { self.rawValue }
        var color: Color {
            switch self {
            case .engage: return .blue
            case .investigate: return .purple
            case .act: return .green
            }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                SparkBackground()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .allowsHitTesting(false)
                
                VStack(spacing: 0) {
                    // Header Spacer for Custom Back Button
                    Color.clear.frame(height: 60)
                    
                    // Persistent Phase Picker (Locked Width)
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach(CBLPhase.allCases) { phase in
                                Button(action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        selectedPhase = phase
                                    }
                                    HapticManager.shared.triggerSelection()
                                }) {
                                    Text(phase.rawValue)
                                        .font(SparkTheme.Typography.cardHeader)
                                        .foregroundColor(selectedPhase == phase ? .white : .white.opacity(0.4))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            ZStack {
                                                if selectedPhase == phase {
                                                    Capsule()
                                                        .fill(phase.color.opacity(0.8))
                                                        .matchedGeometryEffect(id: "activeTab", in: animation)
                                                        .shadow(color: phase.color.opacity(0.4), radius: 8)
                                                }
                                            }
                                        )
                                }
                            }
                        }
                        .padding(4)
                        .background(Capsule().fill(Color.white.opacity(0.05)))
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        
                        Divider()
                            .background(Color.white.opacity(0.1))
                    }
                    .background(.ultraThinMaterial)
                    .frame(width: geo.size.width)
                    
                    // Step Cards List (Locked Width)
                    ScrollView(showsIndicators: false) {
                        let sortedAllSteps = project.steps.sorted { $0.order < $1.order }
                        let currentPhaseSteps = stepsForSelectedPhase
                        
                        VStack(spacing: 20) {
                            ForEach(0..<currentPhaseSteps.count, id: \.self) { index in
                                let step = currentPhaseSteps[index]
                                // Global Lock Check
                                let locked = step.order > 0 && !sortedAllSteps[step.order-1].isCompleted
                                
                                PremiumStepCardView(step: step, phaseColor: selectedPhase.color, isLocked: locked)
                                    .disabled(locked)
                                    .opacity(locked ? 0.6 : 1.0)
                            }
                            Spacer(minLength: 40)
                        }
                        .padding(24)
                        .frame(width: geo.size.width)
                    }
                    .id(selectedPhase)
                }
                .frame(width: geo.size.width)
                
                // Floating Custom Back Button
                Button(action: {
                    HapticManager.shared.triggerImpact(0) // 0 for light
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 0.5))
                        .shadow(color: .black.opacity(0.2), radius: 10)
                }
                .padding(.leading, 20)
                .padding(.top, 10)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden)
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

struct PremiumStepCardView: View {
    let step: CBLStep
    let phaseColor: Color
    let isLocked: Bool
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: StepDetailView(step: step)) {
            GlassCard {
                HStack(spacing: 20) {
                    // Step Index Circle
                    ZStack {
                        Circle()
                            .stroke(phaseColor.opacity(0.3), lineWidth: 1)
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
                        Text(step.type.capitalized)
                            .font(SparkTheme.Typography.cardHeader)
                            .foregroundColor(isLocked ? .white.opacity(0.3) : .white)
                        
                        Text(step.content.isEmpty ? (isLocked ? "Complete previous steps" : "Required input for Phase Completion") : step.content)
                            .font(SparkTheme.Typography.body)
                            .foregroundColor(.white.opacity(0.4))
                            .lineLimit(1)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(step.type.capitalized) Step \(step.order + 1)")
                    .accessibilityValue(isLocked ? "Locked" : (step.isCompleted ? "Completed" : "In Progress"))
                    .accessibilityHint(isLocked ? "You must complete the previous step to unlock this one." : "Tap to open and evolve this idea.")
                    
                    Spacer()
                    
                    // Status Indicator
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
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}
