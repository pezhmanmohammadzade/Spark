import SwiftUI

struct SparkBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Base Deep Layer
            Rectangle()
                .fill(SparkTheme.Gradients.mainBackground)
                .ignoresSafeArea()
            
            // Floating Mesh Circles (Strictly centered and clipped)
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: geo.size.width * 1.5)
                        .blur(radius: 60)
                        .offset(x: animate ? -50 : 50, y: animate ? -100 : 100)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: geo.size.width * 1.2)
                        .blur(radius: 80)
                        .offset(x: animate ? 50 : -50, y: animate ? 100 : -100)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped() // Hard-Lock to parent geometry
            }
            .allowsHitTesting(false)
            
            // Texture Grain
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.3)
                .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}
