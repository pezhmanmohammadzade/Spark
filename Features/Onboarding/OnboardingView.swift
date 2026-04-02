import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var scanPhase = 0
    @State private var scanProgress: Double = 0
    @State private var showButton = false
    @State private var chargeLevel: Double = 0
    @State private var isCharging = false
    @State private var cubeRotation: Double = 0
    
    let scanMessages = [
        "SCANNING FOR OVERCONFIDENCE... (98% DETECTED. TYPICAL.)",
        "SEARCHING FOR UNFINISHED SIDEPODCASTS...",
        "CALIBRATING EGO... ATTEMPTING TO COMPRESS MASSIVE SELF-ESTEEM.",
        "SMELLING FOR BURNT COFFEE AND DESPERATION.",
        "NEURAL SYNC COMPLETE. YOU ARE NOW 'IDEA TODDLER (V2)'."
    ]
    
    var body: some View {
        ZStack {
            SparkBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // 3D Logic Cube
                ZStack {
                    LogicCubeView()
                        .frame(width: 150, height: 150)
                        .rotation3DEffect(.degrees(cubeRotation), axis: (x: 1, y: 1, z: 0))
                    
                    // Scanning Beam overlay
                    Rectangle()
                        .fill(LinearGradient(colors: [.clear, SparkTheme.Colors.xpElectric, .clear], startPoint: .top, endPoint: .bottom))
                        .frame(width: 200, height: 4)
                        .offset(y: CGFloat(sin(cubeRotation * 0.1) * 75))
                        .blur(radius: 4)
                }
                .padding(.bottom, 20)
                
                // Dynamic funny messages
                Text(scanMessages[scanPhase])
                    .font(SparkTheme.Typography.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .frame(height: 80)
                    .animation(.easeInOut, value: scanPhase)
                
                Spacer()
                
                if showButton {
                    initiateButton
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    ProgressView(value: scanProgress)
                        .tint(SparkTheme.Colors.xpElectric)
                        .frame(width: 200)
                        .padding(.bottom, 60)
                }
            }
        }
        .onAppear {
            startScan()
            startCubeRotation()
        }
    }
    
    private var initiateButton: some View {
        VStack(spacing: 12) {
            Text("HOLD TO INITIATE ENGINE")
                .font(SparkTheme.Typography.micro)
                .foregroundColor(.white.opacity(0.4))
                .tracking(2)
            
            ZStack {
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 280, height: 64)
                
                Capsule()
                    .fill(Color.white)
                    .frame(width: 280 * chargeLevel, height: 64)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(chargeLevel >= 1.0 ? "IGNITION" : "INITIATE ENGINE")
                    .font(.headline.bold())
                    .foregroundColor(chargeLevel >= 0.5 ? .black : .white)
            }
            .frame(width: 280, height: 64)
            .rotation3DEffect(.degrees(isCharging ? -10 : 20), axis: (x: 1, y: 0, z: 0))
            .shadow(color: .white.opacity(0.2), radius: isCharging ? 5 : 20)
            .onLongPressGesture(minimumDuration: 1.5, maximumDistance: .infinity, pressing: { pressing in
                isCharging = pressing
                if pressing {
                    HapticManager.shared.triggerImpact(1)
                    withAnimation(.linear(duration: 1.5)) {
                        chargeLevel = 1.0
                    }
                } else {
                    if chargeLevel < 1.0 {
                        withAnimation(.easeOut(duration: 0.3)) {
                            chargeLevel = 0
                        }
                    }
                }
            }, perform: {
                HapticManager.shared.triggerSuccess()
                withAnimation {
                    hasCompletedOnboarding = true
                }
            })
        }
        .padding(.bottom, 60)
    }
    
    private func startScan() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if scanProgress < 1.0 {
                scanProgress += 0.01
                
                let currentPhase = Int(scanProgress * 4.99)
                if currentPhase < scanMessages.count && currentPhase != scanPhase {
                    scanPhase = currentPhase
                    HapticManager.shared.triggerImpact(0)
                }
            } else {
                timer.invalidate()
                withAnimation(.spring()) {
                    showButton = true
                }
            }
        }
    }
    
    private func startCubeRotation() {
        withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
            cubeRotation = 360
        }
    }
}

// Minimalist 3D Logic Cube
struct LogicCubeView: View {
    var body: some View {
        ZStack {
            // Back faces/frame
            RoundedRectangle(cornerRadius: 12)
                .stroke(SparkTheme.Colors.xpElectric.opacity(0.2), lineWidth: 1)
                .offset(z: -75)
            
            // Front faces/frame
            RoundedRectangle(cornerRadius: 12)
                .stroke(SparkTheme.Colors.xpElectric, lineWidth: 2)
                .offset(z: 75)
            
            // Connecting edges (simplified with lines in ZStack)
            ForEach(0..<4) { i in
                Rectangle()
                    .fill(SparkTheme.Colors.xpElectric.opacity(0.4))
                    .frame(width: 2, height: 150)
                    .rotation3DEffect(.degrees(90), axis: (x: 0, y: 1, z: 0))
                    .offset(x: i % 2 == 0 ? 75 : -75, y: i < 2 ? 0 : 0)
            }
            
            // Central "Neural Core"
            Circle()
                .fill(SparkTheme.Colors.xpElectric)
                .frame(width: 40, height: 40)
                .blur(radius: 10)
                .shadow(color: SparkTheme.Colors.xpElectric, radius: 20)
        }
    }
}

// Extension to allow Z-offsetting in SwiftUI views for better 3D layering
extension View {
    func offset(z: CGFloat) -> some View {
        self.modifier(ZOffsetModifier(z: z))
    }
}

struct ZOffsetModifier: ViewModifier {
    let z: CGFloat
    func body(content: Content) -> some View {
        content.transformEffect(.init(translationX: 0, y: 0)) // Placeholder for real Z-sort
            .projectionEffect(.init(.init(translationX: 0, y: 0)))
            .rotation3DEffect(.degrees(0), axis: (x: 0, y: 0, z: 0), anchor: .center, anchorZ: z, perspective: 1)
    }
}
