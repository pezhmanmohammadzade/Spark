import SwiftUI

public struct SparkTerminal: View {
    @State private var currentText: String = ""
    @State private var messageIndex: Int = 0
    
    let allMessages = [
        "INITIALIZING SPARK CORE...",
        "SCANNING FOR COGNITIVE PARADOXES...",
        "SYSTEM: STREAK IDENTIFIED. EFFICIENCY +12%",
        "WEAK POINT DETECTED IN CHALLENGE ARCHITECTURE.",
        "ADVISORY: METABOLIC FRICTION IS INCREASING.",
        "RECURSIVE LOOP ESTABLISHED.",
        "GOAL: TRANSFORMATION OF RAW SPARK TO REALITY.",
        "OPTIMIZING NEURAL PATHWAYS...",
        "STATUS: STANDBY FOR COGNITIVE EVOLUTION."
    ]
    
    let timer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 6, height: 6)
                Text("SPARK TERMINAL v4.2.0")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundColor(.green.opacity(0.7))
                Spacer()
            }
            
            Text("> \(currentText)")
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundColor(.green)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity)
                .id(currentText)
        }
        .padding(12)
        .background(Color.black.opacity(0.4))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.green.opacity(0.2), lineWidth: 0.5))
        .onReceive(timer) { _ in
            updateTerminal()
        }
        .onAppear {
            updateTerminal()
        }
    }
    
    private func updateTerminal() {
        withAnimation {
            currentText = allMessages[messageIndex]
            messageIndex = (messageIndex + 1) % allMessages.count
        }
    }
}
