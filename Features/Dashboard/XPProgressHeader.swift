import SwiftUI

struct XPProgressHeader: View {
    let stats: UserStats
    
    var body: some View {
        HStack(spacing: 16) {
            // Level Badge
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [SparkTheme.Colors.levelGold, .orange], startPoint: .top, endPoint: .bottom))
                    .frame(width: 50, height: 50)
                    .shadow(color: SparkTheme.Colors.levelGold.opacity(0.4), radius: 10)
                
                Text("\(stats.level)")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(.black)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Level \(stats.level)")
                        .font(SparkTheme.Typography.cardHeader)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(stats.currentXP) / \(stats.xpForNextLevel) XP")
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                // Liquid XP Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 10)
                        
                        Capsule()
                            .fill(LinearGradient(colors: [SparkTheme.Colors.xpElectric, .blue], startPoint: .leading, endPoint: .trailing))
                            .frame(width: max(0, min(geo.size.width, geo.size.width * CGFloat(stats.currentXP) / CGFloat(stats.xpForNextLevel))), height: 10)
                            .shadow(color: SparkTheme.Colors.xpElectric.opacity(0.5), radius: 5)
                    }
                }
                .frame(height: 10)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
    }
}
