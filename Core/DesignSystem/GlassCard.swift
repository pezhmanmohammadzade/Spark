import SwiftUI

public struct GlassCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 24
    var showInnerShadow: Bool = true
    
    public init(cornerRadius: CGFloat = 24, showInnerShadow: Bool = true, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.showInnerShadow = showInnerShadow
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            // Main Glass Plate
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white.opacity(0.05))
                .background(.ultraThinMaterial)
            
            // Inner Depth Border (Highlight)
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.4), .clear, .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
            
            // Content
            content
                .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

// Preview Mockup
struct GlassCard_RefinedPreviews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SparkTheme.Gradients.mainBackground.edgesIgnoringSafeArea(.all)
            GlassCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Refined Material")
                        .font(SparkTheme.Typography.cardHeader)
                        .foregroundColor(.blue)
                    Text("System-level blur with 1pt inner highlights.")
                        .font(SparkTheme.Typography.body)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 320, height: 180)
        }
    }
}
