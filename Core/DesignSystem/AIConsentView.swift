import SwiftUI

/// Immersive "Neural Link Initialization" consent view with terminal animation and haptics.
public struct AIConsentView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var consentManager = AIConsentManager.shared
    
    public var onContinue: () -> Void
    public var onCancel: () -> Void
    
    @State private var visibleLines: [String] = []
    @State private var showButtons = false
    @State private var showParticleBurst = false
    @State private var orbPulse = false
    
    private let terminalLines = [
        "> NEURAL LINK INITIALIZATION v4.2...",
        "> ESTABLISHING SECURE CHANNEL...",
        "> SCANNING COGNITIVE ARCHITECTURE...",
        "> WARNING: THIS AI WILL CHALLENGE YOU BRUTALLY.",
        "> PREPARING SOCRATIC EVALUATION ENGINE...",
        "> ALL DATA PROCESSED SECURELY. NO IDENTITY STORED.",
        "> CONSENT REQUIRED TO PROCEED."
    ]
    
    public init(onContinue: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.onContinue = onContinue
        self.onCancel = onCancel
    }
    
    public var body: some View {
        ZStack {
            SparkBackground().ignoresSafeArea()
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack(spacing: 0) {
                terminalHeader
                terminalBody
                Spacer()
                orbSection
                Spacer()
                if showButtons { ctaSection.transition(.move(edge: .bottom).combined(with: .opacity)) }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            runTerminalSequence()
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) { orbPulse = true }
        }
    }
    
    private var terminalHeader: some View {
        HStack {
            Circle().fill(SparkTheme.Colors.neuralGreen).frame(width: 8, height: 8)
            Text("SPARK_NEURAL_LINK v4.2.0")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(SparkTheme.Colors.neuralGreen.opacity(0.7))
            Spacer()
            Text("SECURE")
                .font(.system(size: 8, weight: .black, design: .monospaced))
                .foregroundColor(SparkTheme.Colors.neuralGreen.opacity(0.4))
                .padding(.horizontal, 6).padding(.vertical, 2)
                .background(SparkTheme.Colors.neuralGreen.opacity(0.1))
                .cornerRadius(4)
        }
        .padding(.horizontal, 24).padding(.top, 60)
    }
    
    private var terminalBody: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(Array(visibleLines.enumerated()), id: \.offset) { _, line in
                Text(line)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(lineColor(for: line))
                    .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .opacity))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24).padding(.top, 24)
    }
    
    private var orbSection: some View {
        ZStack {
            if showParticleBurst {
                FloatingParticlesBurst(color: SparkTheme.Colors.xpElectric, radius: 60, particleCount: 16)
                    .frame(width: 140, height: 140)
                    .transition(.scale.combined(with: .opacity))
            }
            FloatingParticlesBurst(color: SparkTheme.Colors.neuralGreen, radius: 50, particleCount: 8)
                .frame(width: 120, height: 120).opacity(showButtons ? 1 : 0.4)
            Spark3DOrb(size: 90, color: showParticleBurst ? SparkTheme.Colors.xpElectric : SparkTheme.Colors.neuralGreen)
                .shadow(color: (showParticleBurst ? SparkTheme.Colors.xpElectric : SparkTheme.Colors.neuralGreen).opacity(0.6), radius: 30)
                .scaleEffect(orbPulse ? 1.08 : 0.95)
            Image(systemName: "brain.head.profile")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
                .shadow(color: SparkTheme.Colors.neuralGreen.opacity(0.5), radius: 8)
        }
        .frame(height: 160)
    }
    
    private var ctaSection: some View {
        VStack(spacing: 16) {
            Button(action: handleAccept) {
                HStack {
                    Image(systemName: "bolt.shield.fill")
                    Text("INITIALIZE NEURAL LINK").fontWeight(.black)
                    Spacer()
                    Image(systemName: "chevron.right.2")
                }
                .font(.subheadline).foregroundColor(.black)
                .padding(.horizontal, 24).padding(.vertical, 18)
                .background(Capsule().fill(SparkTheme.Colors.xpElectric))
                .shadow(color: SparkTheme.Colors.xpElectric.opacity(0.4), radius: 12)
                .shimmerEffect()
            }
            
            Button(action: { HapticManager.shared.triggerSelection(); onCancel(); dismiss() }) {
                Text("ABORT SEQUENCE")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.4)).padding(.vertical, 12)
            }
            
            Button(action: {
                if let url = URL(string: "https://tabby-hammer-a8f.notion.site/spark-ai-policy-342778c3ecb980baa53dcbfb8eb711cd?pvs=73") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("PRIVACY PROTOCOL")
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(SparkTheme.Colors.neuralGreen.opacity(0.6)).tracking(2)
            }.padding(.top, 4)
        }
        .padding(.horizontal, 32).padding(.bottom, 50)
    }
    
    private func runTerminalSequence() {
        for i in 0..<terminalLines.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.6) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    visibleLines.append(terminalLines[i])
                }
                if terminalLines[i].contains("WARNING") {
                    HapticManager.shared.triggerImpact(4)
                } else {
                    HapticManager.shared.triggerImpact(0)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(terminalLines.count) * 0.6 + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) { showButtons = true }
            HapticManager.shared.triggerSelection()
        }
    }
    
    private func lineColor(for line: String) -> Color {
        if line.contains("WARNING") { return SparkTheme.Colors.streakFlame }
        if line.contains("CONSENT") { return SparkTheme.Colors.xpElectric }
        return SparkTheme.Colors.neuralGreen
    }
    
    private func handleAccept() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { showParticleBurst = true }
        HapticManager.shared.triggerSuccess()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            consentManager.grantConsent(); onContinue(); dismiss()
        }
    }
}
