import SwiftUI

enum SparkTheme {
    enum Colors {
        // HSL-Curated Primary Palette
        static let accent = Color(hue: 0.6, saturation: 0.8, brightness: 1.0) // Deep Electric Blue
        static let primary = Color.white
        static let secondary = Color.gray.opacity(0.8)
        
        static let glassBackground = Color.white.opacity(0.08)
        static let glassBorder = Color.white.opacity(0.15)
        
        // Colorblind-Friendly Neon Palette
        static let levelGold = Color(hue: 0.12, saturation: 0.8, brightness: 1.0)
        static let xpElectric = Color(hue: 0.55, saturation: 0.9, brightness: 1.0) // Deep Cyan
        static let streakFlame = Color(hue: 0.08, saturation: 0.9, brightness: 1.0) // High-contrast Orange-Red
        
        // Phase Colors (Accessible Contrast)
        static let engage = Color(hue: 0.6, saturation: 0.8, brightness: 1.0) // Strong Blue
        static let investigate = Color(hue: 0.8, saturation: 0.7, brightness: 1.0) // Deep Purple
        static let act = Color(hue: 0.15, saturation: 0.9, brightness: 1.0) // Bright Yellow/Gold (Accessible replacement for Green)
    }
    
    enum Gradients {
        static let mainBackground = LinearGradient(
            colors: [Color.black, Color(red: 0.05, green: 0.02, blue: 0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let levelUp = RadialGradient(
            colors: [Colors.levelGold, .clear],
            center: .center,
            startRadius: 0,
            endRadius: 300
        )
    }
    
    enum Typography {
        static func title(size: CGFloat = 34) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
        
        static let bentoHeader = Font.system(size: 20, weight: .bold, design: .rounded)
        static let cardHeader = Font.system(.headline, design: .rounded).weight(.semibold)
        static let body = Font.system(.body, design: .rounded)
        static let micro = Font.system(size: 10, weight: .black, design: .rounded)
    }
}

// Global Extensions
extension View {
    func bentoStyle(cornerRadius: CGFloat = 28) -> some View {
        self
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
}

// Lightweight Haptic Utility
class HapticManager {
    @MainActor static let shared = HapticManager()
    
    @MainActor func triggerImpact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    @MainActor func triggerSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    @MainActor func triggerSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
}
