import SwiftUI
import SwiftData

public struct StreakCard: View {
    public let streak: Int
    public let multiplier: Double
    public let shields: Int
    
    @State private var pulse = false
    
    public init(streak: Int, multiplier: Double = 1.0, shields: Int = 0) {
        self.streak = streak
        self.multiplier = multiplier
        self.shields = shields
    }
    
    public var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    ZStack {
                        Spark3DCrystal(size: 48, color: SparkTheme.Colors.streakFlame)
                            .offset(x: 2, y: -1)
                        
                        Circle()
                            .fill(SparkTheme.Colors.streakFlame.opacity(0.1))
                            .frame(width: 40, height: 40)
                            .scaleEffect(pulse ? 1.2 : 1.0)
                            .opacity(pulse ? 0.3 : 0.7)
                        
                        Image(systemName: "flame.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(SparkTheme.Colors.streakFlame)
                            .shadow(color: SparkTheme.Colors.streakFlame.opacity(0.4), radius: 8)
                            .rotation3DEffect(
                                .degrees(pulse ? 18 : -18),
                                axis: (x: 0, y: 1, z: 0.2),
                                perspective: 0.6
                            )
                    }
                    .frame(width: 48, height: 48)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(streakLabel)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor((streak > 0 ? SparkTheme.Colors.streakFlame : Color.gray).opacity(0.9))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background((streak > 0 ? SparkTheme.Colors.streakFlame : Color.gray).opacity(0.2))
                            .cornerRadius(8)
                        
                        // Streak Multiplier Badge
                        if multiplier > 1.0 {
                            Text("x\(String(format: "%.1f", multiplier))")
                                .font(.system(size: 10, weight: .black, design: .rounded))
                                .foregroundColor(SparkTheme.Colors.xpElectric)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(SparkTheme.Colors.xpElectric.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                }
                
                Spacer(minLength: 8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(streak)")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    HStack(spacing: 6) {
                        Text("DAY STREAK")
                            .font(SparkTheme.Typography.micro)
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(1)
                        
                        // Neural Shield indicator
                        if shields > 0 {
                            HStack(spacing: 3) {
                                Image(systemName: "shield.checkered")
                                    .font(.system(size: 9, weight: .bold))
                                Text("\(shields)")
                                    .font(.system(size: 9, weight: .black, design: .rounded))
                            }
                            .foregroundColor(SparkTheme.Colors.shieldBlue)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(SparkTheme.Colors.shieldBlue.opacity(0.15))
                            .cornerRadius(4)
                            .scaleEffect(pulse ? 1.05 : 1.0)
                        }
                    }
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
        }
        .frame(height: 160)
        .parallax3DTilt(maxAngle: 7)
    }
    
    private var streakLabel: String {
        if streak == 0 { return "COLD" }
        if streak < 3 { return "WARM" }
        if streak < 7 { return "HOT" }
        if streak < 14 { return "NOVA" }
        if streak < 30 { return "SUPERNOVA" }
        return "ETERNAL"
    }
}
