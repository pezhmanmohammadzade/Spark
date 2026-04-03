import SwiftUI
import SwiftData

public struct StreakCard: View {
    public let streak: Int
    @State private var pulse = false
    
    public init(streak: Int) {
        self.streak = streak
    }
    
    public var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(SparkTheme.Colors.streakFlame.opacity(0.1))
                            .frame(width: 40, height: 40)
                            .scaleEffect(pulse ? 1.2 : 1.0)
                            .opacity(pulse ? 0.3 : 0.7)
                        
                        Image(systemName: "flame.fill")
                            .font(.title2)
                            .foregroundColor(SparkTheme.Colors.streakFlame)
                            .shadow(color: SparkTheme.Colors.streakFlame.opacity(0.4), radius: 8)
                    }
                    
                    Spacer()
                    
                    Text("\(streak)")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(streak > 0 ? SparkTheme.Colors.streakFlame : Color.gray)
                        .frame(width: 6, height: 6)
                    
                    Text(streakLabel)
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(2)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
        }
    }
    
    private var streakLabel: String {
        if streak == 0 { return "COLD" }
        if streak < 3 { return "WARM" }
        if streak < 7 { return "HOT" }
        return "NOVA"
    }
}
