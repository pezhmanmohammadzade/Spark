import SwiftUI

public struct AdvancedStatCard: View {
    public let title: String
    public let value: String
    public let icon: String
    public let color: Color
    public let trend: String?
    
    public init(title: String, value: String, icon: String, color: Color, trend: String? = nil) {
        self.title = title
        self.value = value
        self.icon = icon
        self.color = color
        self.trend = trend
    }
    
    @State private var isHovering = false
    
    public var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    ZStack {
                        Spark3DPrism(size: 48, color: color)
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: color.opacity(0.9), radius: 4)
                    }
                    .frame(width: 48, height: 48)
                    
                    Spacer()
                    
                    if let trend = trend {
                        Text(trend)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(color.opacity(0.9))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(color.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                
                Spacer(minLength: 8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(value)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Text(title.uppercased())
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(1)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 160)
        .parallax3DTilt(maxAngle: 7)
        .scaleEffect(isHovering ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovering)
    }
}
