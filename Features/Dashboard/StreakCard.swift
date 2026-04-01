import SwiftUI

struct StreakCard: View {
    let streak: Int
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundColor(SparkTheme.Colors.streakFlame)
                        .shadow(color: SparkTheme.Colors.streakFlame.opacity(0.4), radius: 8)
                    Spacer()
                    Text("\(streak)")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Text(streak > 0 ? "STREAK ACTIVE" : "START STREAK")
                    .font(SparkTheme.Typography.micro)
                    .foregroundColor(.white.opacity(0.4))
                    .tracking(2)
            }
        }
    }
}
