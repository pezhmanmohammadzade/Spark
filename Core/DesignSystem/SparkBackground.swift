import SwiftUI

struct SparkBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Base Deep Layer
            Rectangle()
                .fill(SparkTheme.Gradients.mainBackground)
                .ignoresSafeArea()
            
            // Floating Mesh Circles (Anchored to screen, avoiding keyboard resizing)
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: max(geo.size.width, geo.size.height) * 1.5)
                        .blur(radius: 60)
                        .offset(x: animate ? -50 : 50, y: animate ? -100 : 100)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: max(geo.size.width, geo.size.height) * 1.2)
                        .blur(radius: 80)
                        .offset(x: animate ? 50 : -50, y: animate ? 100 : -100)
                }
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
            .ignoresSafeArea(.all) // FIXED: Background doesn't shrink when keyboard appears
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
