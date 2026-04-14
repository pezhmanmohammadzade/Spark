import SwiftUI

public struct AIConsentView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var consentManager = AIConsentManager.shared
    
    public var onContinue: () -> Void
    public var onCancel: () -> Void
    
    public init(onContinue: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.onContinue = onContinue
        self.onCancel = onCancel
    }
    
    public var body: some View {
        ZStack {
            // Spark-themed background for the sheet
            SparkTheme.Gradients.mainBackground
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Visual Accent - 3D Orb for premium feel
                ZStack {
                    Spark3DOrb(size: 80, color: SparkTheme.Colors.xpElectric)
                        .shadow(color: SparkTheme.Colors.xpElectric.opacity(0.5), radius: 20)
                    
                    Image(systemName: "hand.raised.shield.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 16) {
                    Text("AI Processing Consent")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Your input may be sent securely to a third-party AI service to generate responses. By continuing, you agree to this processing.")
                        .font(SparkTheme.Typography.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Text("Spark uses external AI processing only to provide AI-generated guidance and feedback.")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    // Continue Action
                    Button(action: {
                        HapticManager.shared.triggerSuccess()
                        consentManager.grantConsent()
                        onContinue()
                        dismiss()
                    }) {
                        Text("Continue")
                            .font(.headline.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Capsule().fill(SparkTheme.Colors.xpElectric))
                            .shadow(color: SparkTheme.Colors.xpElectric.opacity(0.3), radius: 10)
                    }
                    
                    // Cancel Action
                    Button(action: {
                        HapticManager.shared.triggerSelection()
                        onCancel()
                        dismiss()
                    }) {
                        Text("Not Now")
                            .font(.headline.bold())
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                    }
                    
                    // Privacy Policy
                    Button(action: {
                        if let url = URL(string: "https://tabby-hammer-a8f.notion.site/spark-ai-policy-342778c3ecb980baa53dcbfb8eb711cd?pvs=73") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Privacy Policy")
                            .font(SparkTheme.Typography.micro)
                            .foregroundColor(SparkTheme.Colors.xpElectric)
                            .tracking(1)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct AIConsentView_Previews: PreviewProvider {
    static var previews: some View {
        AIConsentView(onContinue: {}, onCancel: {})
    }
}
