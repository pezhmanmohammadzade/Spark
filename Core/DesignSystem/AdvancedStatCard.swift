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
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.15))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(color)
                    }
                    
                    Spacer()
                    
                    if let trend = trend {
                        Text(trend)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(color.opacity(0.8))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(color.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(value)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(title.uppercased())
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scaleEffect(isHovering ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovering)
        .onAppear {
            // Subtle entrance animation could go here
        }
    }
}
