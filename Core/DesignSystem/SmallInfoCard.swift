import SwiftUI

struct SmallInfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                // Icon Glow
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(SparkTheme.Colors.accent)
                    .shadow(color: SparkTheme.Colors.accent.opacity(0.3), radius: 5)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(value)
                        .font(SparkTheme.Typography.cardHeader)
                        .foregroundColor(.white)
                    Text(title.uppercased())
                        .font(SparkTheme.Typography.micro)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
