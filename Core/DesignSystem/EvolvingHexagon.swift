import SwiftUI

public struct EvolvingHexagon: View {
    let level: Int
    let color: Color
    
    public init(level: Int, color: Color) {
        self.level = level
        self.color = color
    }
    
    public var body: some View {
        ZStack {
            // Base Layer
            HexagonShape()
                .fill(color.opacity(0.1))
                .overlay(HexagonShape().stroke(color.opacity(0.3), lineWidth: 1))
            
            // Tier 2: Double Walled (Lvl 6+)
            if level >= 6 {
                HexagonShape()
                    .stroke(color.opacity(0.5), lineWidth: 1)
                    .scaleEffect(0.85)
                    .rotationEffect(.degrees(animate ? 10 : -10))
            }
            
            // Tier 3: 3D Crystal / Orbit (Lvl 16+)
            if level >= 16 {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 0.5)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .fill(color)
                    .frame(width: 4, height: 4)
                    .offset(x: 40)
                    .rotationEffect(.degrees(animate ? 360 : 0))
            }
            
            // Level Text
            Text("\(level)")
                .font(.system(size: level >= 10 ? 16 : 20, weight: .black, design: .rounded))
                .foregroundColor(color)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
    
    @State private var animate = false
}

// Re-using the HexagonShape from my previous knowledge or creating it if needed
public struct HexagonShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let center = CGPoint(x: width / 2, y: height / 2)
        let radius = min(width, height) / 2
        
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}
