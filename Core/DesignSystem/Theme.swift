import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public enum SparkTheme {
    public enum Colors {
        public static let accent = Color(hue: 0.6, saturation: 0.8, brightness: 1.0)
        public static let primary = Color.white
        public static let secondary = Color.gray.opacity(0.8)
        public static let glassBackground = Color.white.opacity(0.08)
        public static let glassBorder = Color.white.opacity(0.15)
        public static let levelGold = Color(hue: 0.12, saturation: 0.8, brightness: 1.0)
        public static let xpElectric = Color(hue: 0.55, saturation: 0.9, brightness: 1.0)
        public static let streakFlame = Color(hue: 0.08, saturation: 0.9, brightness: 1.0)
        public static let engage = Color(hue: 0.6, saturation: 0.8, brightness: 1.0)
        public static let investigate = Color(hue: 0.8, saturation: 0.7, brightness: 1.0)
        public static let act = Color(hue: 0.15, saturation: 0.9, brightness: 1.0)
        
        // Reactive UI Colors (Score-based)
        public static let criticalHit = Color(hue: 0.12, saturation: 1.0, brightness: 1.0)
        public static let shieldBlue = Color(hue: 0.58, saturation: 0.7, brightness: 0.95)
        public static let neuralGreen = Color(hue: 0.38, saturation: 0.85, brightness: 0.9)
        public static let harshFail = Color(hue: 0.02, saturation: 0.9, brightness: 0.95)
    }
    
    public enum Typography {
        public static func title(size: CGFloat = 34) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
        public static let bentoHeader = Font.system(size: 20, weight: .bold, design: .rounded)
        public static let cardHeader = Font.system(.headline, design: .rounded).weight(.semibold)
        public static let body = Font.system(.body, design: .rounded)
        public static let micro = Font.system(size: 10, weight: .black, design: .rounded)
    }
    
    public enum Gradients {
        public static let mainBackground = LinearGradient(
            colors: [Color(red: 0.05, green: 0.05, blue: 0.1), Color(red: 0.1, green: 0.1, blue: 0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension View {
    public func bentoStyle(cornerRadius: CGFloat = 28) -> some View {
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
    
    public func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

@MainActor
public class HapticManager {
    public static let shared = HapticManager()
    private init() {}
    
    public func triggerImpact(_ style: Int = 0) {
        #if canImport(UIKit)
        let styles: [UIImpactFeedbackGenerator.FeedbackStyle] = [.light, .medium, .heavy, .soft, .rigid]
        let generator = UIImpactFeedbackGenerator(style: styles[min(max(style, 0), 4)])
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    public func triggerSelection() {
        #if canImport(UIKit)
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        #endif
    }
    
    public func triggerSuccess() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        #endif
    }
    
    public func triggerError() {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
        #endif
    }
}
