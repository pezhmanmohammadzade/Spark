import SwiftUI

public struct SparkMeshBackground: View {
    @State private var t: CGFloat = 0
    @State private var touchPoint: CGPoint = .zero
    @State private var isTouching = false
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Deep Layer
            Color(red: 0.02, green: 0.03, blue: 0.08)
                .ignoresSafeArea()
            
            // Mesh Layer
            Canvas { context, size in
                t += 0.01
                
                _ = size.width
                _ = size.height
                
                // Drawing 4 vibrant "liquid" blobs
                drawBlob(context: context, size: size, color: .blue, offset: CGPoint(x: sin(t * 0.5) * 100, y: cos(t * 0.8) * 150), scale: 1.2)
                drawBlob(context: context, size: size, color: .purple, offset: CGPoint(x: cos(t * 0.7) * 120, y: sin(t * 0.5) * 100), scale: 1.5)
                drawBlob(context: context, size: size, color: Color(red: 0, green: 0.8, blue: 1.0), offset: CGPoint(x: sin(t * 0.9) * 80, y: cos(t * 0.6) * 90), scale: 1.0)
            }
            .blur(radius: 80)
            .ignoresSafeArea()
            
            // Particle Layer (Touch Responsive)
            ParticleView(touchPoint: touchPoint, isTouching: isTouching)
                .ignoresSafeArea()
            
            // Grain Texture
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.4)
                .ignoresSafeArea()
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    touchPoint = value.location
                    isTouching = true
                }
                .onEnded { _ in
                    isTouching = false
                }
        )
        .onReceive(timer) { _ in
            t += 0.01
        }
    }
    
    private func drawBlob(context: GraphicsContext, size: CGSize, color: Color, offset: CGPoint, scale: CGFloat) {
        let rect = CGRect(
            x: (size.width / 2) + offset.x - (200 * scale / 2),
            y: (size.height / 2) + offset.y - (200 * scale / 2),
            width: 200 * scale,
            height: 200 * scale
        )
        context.fill(Path(ellipseIn: rect), with: .color(color.opacity(0.4)))
    }
}

struct ParticleView: View {
    let touchPoint: CGPoint
    let isTouching: Bool
    
    @State private var particles: [Particle] = []
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Canvas { context, size in
            for particle in particles {
                let rect = CGRect(x: particle.x, y: particle.y, width: particle.size, height: particle.size)
                context.opacity = particle.opacity
                context.fill(Path(ellipseIn: rect), with: .color(particle.color))
            }
        }
        .onReceive(timer) { _ in
            updateParticles()
        }
    }
    
    private func updateParticles() {
        // Add new particles if touching
        if isTouching {
            for _ in 0...2 {
                let p = Particle(
                    x: touchPoint.x + CGFloat.random(in: -10...10),
                    y: touchPoint.y + CGFloat.random(in: -10...10),
                    vx: CGFloat.random(in: -2...2),
                    vy: CGFloat.random(in: -2...2),
                    size: CGFloat.random(in: 2...5),
                    color: [Color.blue, Color.cyan, Color.white].randomElement()!,
                    opacity: 1.0,
                    life: 1.0
                )
                particles.append(p)
            }
        }
        
        // Update existing particles
        var nextParticles: [Particle] = []
        for var p in particles {
            p.x += p.vx
            p.y += p.vy
            p.life -= 0.02
            p.opacity = p.life
            if p.life > 0 {
                nextParticles.append(p)
            }
        }
        particles = nextParticles
    }
}

struct Particle {
    var x, y, vx, vy, size: CGFloat
    var color: Color
    var opacity, life: CGFloat
}
