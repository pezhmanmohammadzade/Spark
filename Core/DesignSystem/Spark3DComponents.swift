import SwiftUI
import SceneKit

#if canImport(UIKit)
import UIKit
private typealias _PColor = UIColor
#elseif canImport(AppKit)
import AppKit
private typealias _PColor = NSColor
#endif

// MARK: - Transparent3DSceneView
/// UIViewRepresentable wrapper for SCNView with transparent background.
/// SwiftUI's built-in SceneView always renders with an opaque white background —
/// this replacement sets backgroundColor = .clear so 3D objects float over the glass card.
#if canImport(UIKit)
private struct Transparent3DSceneView: UIViewRepresentable {
    let scene: SCNScene

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = scene
        scnView.backgroundColor = .clear
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = false
        scnView.isPlaying = true
        scnView.preferredFramesPerSecond = 60
        scnView.rendersContinuously = true
        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}
#endif

// MARK: - Spark3DOrb
/// A miniature SceneKit glowing orb. Uses the same lighting setup as the splash screen.
public struct Spark3DOrb: View {
    public var size: CGFloat = 60
    public var color: Color = SparkTheme.Colors.xpElectric
    
    public init(size: CGFloat = 60, color: Color = SparkTheme.Colors.xpElectric) {
        self.size = size
        self.color = color
    }
    
    public var body: some View {
        Transparent3DSceneView(scene: buildOrbScene())
            .frame(width: size, height: size)
            .clipShape(Circle())
            .allowsHitTesting(false)
    }
    
    private func buildOrbScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = _PColor.clear
        
        // Outer shell – low-poly wireframe sphere
        let shellGeo = SCNSphere(radius: 0.55)
        shellGeo.segmentCount = 6
        let shellMat = SCNMaterial()
        shellMat.fillMode = .lines
        shellMat.diffuse.contents = _PColor.white.withAlphaComponent(0.15)
        shellMat.emission.contents = resolve(color).withAlphaComponent(0.55)
        shellGeo.materials = [shellMat]
        let shellNode = SCNNode(geometry: shellGeo)
        
        // Inner glowing core
        let coreGeo = SCNSphere(radius: 0.22)
        let coreMat = SCNMaterial()
        coreMat.lightingModel = .physicallyBased
        coreMat.metalness.contents = 1.0
        coreMat.roughness.contents = 0.05
        coreMat.diffuse.contents = _PColor.black
        coreMat.emission.contents = resolve(color)
        coreGeo.materials = [coreMat]
        let coreNode = SCNNode(geometry: coreGeo)
        
        // Thin orbit ring
        let ringGeo = SCNTorus(ringRadius: 0.42, pipeRadius: 0.015)
        let ringMat = SCNMaterial()
        ringMat.diffuse.contents = resolve(color).withAlphaComponent(0.4)
        ringMat.emission.contents = resolve(color).withAlphaComponent(0.3)
        ringGeo.materials = [ringMat]
        let ringNode = SCNNode(geometry: ringGeo)
        ringNode.eulerAngles = SCNVector3(Float.pi / 3, 0, 0)
        
        let pivot = SCNNode()
        pivot.addChildNode(shellNode)
        pivot.addChildNode(coreNode)
        pivot.addChildNode(ringNode)
        scene.rootNode.addChildNode(pivot)
        
        // Animations
        pivot.runAction(.repeatForever(.rotateBy(x: 0.3, y: 1.0, z: 0.2, duration: 4.0)))
        coreNode.runAction(.repeatForever(.sequence([
            .scale(to: 1.35, duration: 0.9),
            .scale(to: 1.0, duration: 0.9)
        ])))
        
        // Camera
        let cam = SCNCamera()
        cam.fieldOfView = 55
        let camNode = SCNNode()
        camNode.camera = cam
        camNode.position = SCNVector3(0, 0, 2.5)
        scene.rootNode.addChildNode(camNode)
        
        // Lighting
        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.intensity = 120
        ambient.color = _PColor(red: 0.1, green: 0.15, blue: 0.4, alpha: 1)
        let ambNode = SCNNode(); ambNode.light = ambient
        scene.rootNode.addChildNode(ambNode)
        
        let omni = SCNLight()
        omni.type = .omni
        omni.intensity = 600
        omni.color = resolve(color)
        let omniNode = SCNNode(); omniNode.light = omni
        omniNode.position = SCNVector3(2, 2, 4)
        scene.rootNode.addChildNode(omniNode)
        
        return scene
    }
    
    /// Converts SwiftUI Color to platform UIColor/NSColor for SceneKit.
    private func resolve(_ color: Color) -> _PColor {
        #if canImport(UIKit)
        return UIColor(color)
        #else
        return NSColor(color)
        #endif
    }
}

// MARK: - FloatingParticlesBurst
/// 8 small sparkle dots that orbit a center point continuously.
public struct FloatingParticlesBurst: View {
    public var color: Color = SparkTheme.Colors.xpElectric
    public var radius: CGFloat = 22
    public var particleCount: Int = 8
    
    public init(color: Color = SparkTheme.Colors.xpElectric, radius: CGFloat = 22, particleCount: Int = 8) {
        self.color = color
        self.radius = radius
        self.particleCount = particleCount
    }
    
    @State private var rotation: Double = 0
    @State private var pulse: Bool = false
    
    public var body: some View {
        ZStack {
            ForEach(0..<particleCount, id: \.self) { i in
                let angle = Double(i) * (360.0 / Double(particleCount))
                let orbitRadius = radius + (i % 2 == 0 ? 4 : 0)
                let dotSize: CGFloat = i % 3 == 0 ? 4 : 3
                
                Circle()
                    .fill(color.opacity(i % 2 == 0 ? 0.9 : 0.5))
                    .frame(width: dotSize, height: dotSize)
                    .shadow(color: color.opacity(0.6), radius: 4)
                    .offset(x: orbitRadius)
                    .rotationEffect(.degrees(angle + rotation))
                    .scaleEffect(pulse ? 1.15 : 0.85)
                    .animation(
                        .easeInOut(duration: 1.2 + Double(i) * 0.1).repeatForever(autoreverses: true),
                        value: pulse
                    )
            }
        }
        .onAppear {
            pulse = true
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - ShimmerModifier
/// Sweeps a blurred white gradient stripe across the view — great for CTA buttons.
public struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1
    
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    let width = geo.size.width
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .white.opacity(0.38), location: 0.4),
                            .init(color: .white.opacity(0.55), location: 0.5),
                            .init(color: .white.opacity(0.38), location: 0.6),
                            .init(color: .clear, location: 1),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: width * 0.55)
                    .offset(x: phase * (width + width * 0.55))
                    .blur(radius: 6)
                }
                .clipped()
                .allowsHitTesting(false)
            )
            .onAppear {
                withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) {
                    phase = 1.4
                }
            }
    }
}

public extension View {
    func shimmerEffect() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Parallax3DTiltCard
/// Maps a drag gesture to rotation3DEffect for a depth-tilt card feel.
public struct Parallax3DTiltCard: ViewModifier {
    @State private var tiltX: Double = 0
    @State private var tiltY: Double = 0
    var maxAngle: Double = 8
    
    public init(maxAngle: Double = 8) {
        self.maxAngle = maxAngle
    }
    
    public func body(content: Content) -> some View {
        content
            .rotation3DEffect(.degrees(tiltX), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.degrees(tiltY), axis: (x: 0, y: 1, z: 0))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        withAnimation(.interactiveSpring(response: 0.25, dampingFraction: 0.7)) {
                            let size = CGSize(width: 260, height: 180)
                            tiltX = ((value.location.y / size.height) - 0.5) * -maxAngle * 2
                            tiltY = ((value.location.x / size.width) - 0.5) * maxAngle * 2
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            tiltX = 0
                            tiltY = 0
                        }
                    }
            )
    }
}

public extension View {
    func parallax3DTilt(maxAngle: Double = 8) -> some View {
        modifier(Parallax3DTiltCard(maxAngle: maxAngle))
    }
}

// MARK: - NeuralCircuitBackground
/// Draws a decorative "brain circuit" pattern: random nodes connected by thin lines.
public struct NeuralCircuitBackground: View {
    public var color: Color = SparkTheme.Colors.xpElectric
    public var opacity: Double = 0.12
    
    public init(color: Color = SparkTheme.Colors.xpElectric, opacity: Double = 0.12) {
        self.color = color
        self.opacity = opacity
    }
    
    // Fixed seed so layout is stable across redraws
    private let nodes: [(CGFloat, CGFloat)] = [
        (0.1, 0.2), (0.3, 0.6), (0.5, 0.15), (0.7, 0.5),
        (0.85, 0.25), (0.2, 0.8), (0.6, 0.75), (0.9, 0.8),
        (0.45, 0.9), (0.75, 0.1)
    ]
    
    private let edges: [(Int, Int)] = [
        (0,1),(1,2),(2,3),(3,4),(0,5),(5,6),(6,7),(7,8),(3,6),(2,5),(4,7),(8,9),(4,9)
    ]
    
    public var body: some View {
        Canvas { ctx, size in
            let pts = nodes.map { CGPoint(x: $0.0 * size.width, y: $0.1 * size.height) }
            
            for (a, b) in edges {
                var path = Path()
                path.move(to: pts[a])
                path.addLine(to: pts[b])
                ctx.stroke(path, with: .color(color.opacity(opacity)), lineWidth: 0.7)
            }
            
            for pt in pts {
                let dot = Path(ellipseIn: CGRect(x: pt.x - 2, y: pt.y - 2, width: 4, height: 4))
                ctx.fill(dot, with: .color(color.opacity(opacity * 1.6)))
            }
        }
    }
}

// MARK: - PulsingRingView
/// Three concentric rings that scale out with staggered animation — heartbeat feel.
public struct PulsingRingView: View {
    public var color: Color = SparkTheme.Colors.levelGold
    public var baseSize: CGFloat = 50
    
    public init(color: Color = SparkTheme.Colors.levelGold, baseSize: CGFloat = 50) {
        self.color = color
        self.baseSize = baseSize
    }
    
    @State private var animate = false
    
    public var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .stroke(color.opacity(animate ? 0 : 0.4 - Double(i) * 0.1), lineWidth: 1.5)
                    .frame(width: baseSize, height: baseSize)
                    .scaleEffect(animate ? 1.0 + CGFloat(i + 1) * 0.35 : 1.0)
                    .animation(
                        .easeOut(duration: 1.6)
                        .repeatForever(autoreverses: false)
                        .delay(Double(i) * 0.45),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}

// MARK: - StarFieldLayer
/// Faint floating star dots that drift upward — pure depth decoration.
public struct StarFieldLayer: View {
    public init() {}
    
    private let stars: [(CGFloat, CGFloat, Double, CGFloat)] = (0..<14).map { i in
        let seed = Double(i)
        let x = CGFloat((seed * 137.5).truncatingRemainder(dividingBy: 100)) / 100
        let y = CGFloat((seed * 73.1).truncatingRemainder(dividingBy: 100)) / 100
        let dur = 4.0 + (seed * 0.31).truncatingRemainder(dividingBy: 3.0)
        let size = CGFloat(1.5 + (seed * 0.17).truncatingRemainder(dividingBy: 2.0))
        return (x, y, dur, size)
    }
    
    @State private var drift: CGFloat = 0
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<stars.count, id: \.self) { i in
                    let (nx, ny, _, sz) = stars[i]
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: sz, height: sz)
                        .position(
                            x: nx * geo.size.width,
                            y: (ny * geo.size.height - drift * 30).truncatingRemainder(dividingBy: geo.size.height)
                        )
                        .shadow(color: .white.opacity(0.3), radius: 2)
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 18).repeatForever(autoreverses: false)) {
                drift = 1
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Spark3DPrism
/// A rotating metallic cube with a thin wireframe cage around it — perfect for stat card icons.
public struct Spark3DPrism: View {
    public var size: CGFloat = 44
    public var color: Color = Color.blue
    
    public init(size: CGFloat = 44, color: Color = Color.blue) {
        self.size = size
        self.color = color
    }
    
    public var body: some View {
        Transparent3DSceneView(scene: buildPrismScene())
            .frame(width: size, height: size)
            .allowsHitTesting(false)
    }
    
    private func buildPrismScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = _PColor.clear
        
        let pivot = SCNNode()
        
        // Inner glowing box
        let boxGeo = SCNBox(width: 0.55, height: 0.55, length: 0.55, chamferRadius: 0.06)
        let boxMat = SCNMaterial()
        boxMat.lightingModel = .physicallyBased
        boxMat.metalness.contents = 1.0
        boxMat.roughness.contents = 0.08
        boxMat.diffuse.contents = resolve(color).withAlphaComponent(0.3)
        boxMat.emission.contents = resolve(color).withAlphaComponent(0.55)
        boxGeo.materials = [boxMat]
        let boxNode = SCNNode(geometry: boxGeo)
        pivot.addChildNode(boxNode)
        
        // Outer wireframe cage
        let cageGeo = SCNBox(width: 0.75, height: 0.75, length: 0.75, chamferRadius: 0.04)
        let cageMat = SCNMaterial()
        cageMat.fillMode = .lines
        cageMat.diffuse.contents = _PColor.white.withAlphaComponent(0.12)
        cageMat.emission.contents = resolve(color).withAlphaComponent(0.3)
        cageGeo.materials = [cageMat]
        let cageNode = SCNNode(geometry: cageGeo)
        pivot.addChildNode(cageNode)
        
        scene.rootNode.addChildNode(pivot)
        
        // Compound rotation
        pivot.runAction(.repeatForever(.rotateBy(x: 0.4, y: 1.2, z: 0.25, duration: 3.5)))
        cageNode.runAction(.repeatForever(.rotateBy(x: -0.2, y: 0.5, z: 0.3, duration: 5.0)))
        
        // Camera
        let cam = SCNCamera(); cam.fieldOfView = 52
        let camNode = SCNNode(); camNode.camera = cam
        camNode.position = SCNVector3(0, 0, 2.2)
        scene.rootNode.addChildNode(camNode)
        
        // Lighting
        let ambient = SCNLight(); ambient.type = .ambient; ambient.intensity = 110
        let ambNode = SCNNode(); ambNode.light = ambient; scene.rootNode.addChildNode(ambNode)
        
        let key = SCNLight(); key.type = .omni; key.intensity = 700
        key.color = resolve(color)
        let keyNode = SCNNode(); keyNode.light = key
        keyNode.position = SCNVector3(2, 2, 3); scene.rootNode.addChildNode(keyNode)
        
        let fill = SCNLight(); fill.type = .omni; fill.intensity = 300
        fill.color = _PColor.white
        let fillNode = SCNNode(); fillNode.light = fill
        fillNode.position = SCNVector3(-2, -1, 2); scene.rootNode.addChildNode(fillNode)
        
        return scene
    }
    
    private func resolve(_ color: Color) -> _PColor {
        #if canImport(UIKit)
        return UIColor(color)
        #else
        return NSColor(color)
        #endif
    }
}

// MARK: - Spark3DCrystal
/// A dual-pyramid gem that rotates — great for streak/achievement decorations.
public struct Spark3DCrystal: View {
    public var size: CGFloat = 60
    public var color: Color = Color.orange
    
    public init(size: CGFloat = 60, color: Color = Color.orange) {
        self.size = size
        self.color = color
    }
    
    public var body: some View {
        Transparent3DSceneView(scene: buildCrystalScene())
            .frame(width: size, height: size)
            .allowsHitTesting(false)
    }
    
    private func buildCrystalScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = _PColor.clear
        
        let pivot = SCNNode()
        
        // Shared glowing material
        let crystalMat = SCNMaterial()
        crystalMat.lightingModel = .physicallyBased
        crystalMat.metalness.contents = 0.9
        crystalMat.roughness.contents = 0.04
        crystalMat.diffuse.contents = resolve(color).withAlphaComponent(0.25)
        crystalMat.emission.contents = resolve(color).withAlphaComponent(0.75)
        crystalMat.transparency = 0.15
        
        // Top pyramid (larger)
        let topGeo = SCNPyramid(width: 0.65, height: 0.9, length: 0.65)
        topGeo.materials = [crystalMat]
        let topNode = SCNNode(geometry: topGeo)
        topNode.position = SCNVector3(0, 0.05, 0)
        pivot.addChildNode(topNode)
        
        // Bottom pyramid (smaller, flipped)
        let botGeo = SCNPyramid(width: 0.5, height: 0.55, length: 0.5)
        botGeo.materials = [crystalMat]
        let botNode = SCNNode(geometry: botGeo)
        botNode.eulerAngles.x = .pi
        botNode.position = SCNVector3(0, -0.55, 0)
        pivot.addChildNode(botNode)
        
        // Equator ring
        let ringGeo = SCNTorus(ringRadius: 0.34, pipeRadius: 0.012)
        let ringMat = SCNMaterial()
        ringMat.diffuse.contents = resolve(color).withAlphaComponent(0.6)
        ringMat.emission.contents = resolve(color)
        ringGeo.materials = [ringMat]
        let ringNode = SCNNode(geometry: ringGeo)
        ringNode.position = SCNVector3(0, 0.05, 0)
        pivot.addChildNode(ringNode)
        
        scene.rootNode.addChildNode(pivot)
        
        // Spin with slight wobble
        pivot.runAction(.repeatForever(.rotateBy(x: 0.15, y: 1.8, z: 0.1, duration: 3.8)))
        ringNode.runAction(.repeatForever(.rotateBy(x: 0.3, y: -0.5, z: 0.2, duration: 4.0)))
        
        // Camera
        let cam = SCNCamera(); cam.fieldOfView = 58
        let camNode = SCNNode(); camNode.camera = cam
        camNode.position = SCNVector3(0, 0, 2.5)
        scene.rootNode.addChildNode(camNode)
        
        // Lighting
        let ambient = SCNLight(); ambient.type = .ambient; ambient.intensity = 130
        let ambNode = SCNNode(); ambNode.light = ambient; scene.rootNode.addChildNode(ambNode)
        
        let key = SCNLight(); key.type = .omni; key.intensity = 650
        key.color = resolve(color)
        let keyNode = SCNNode(); keyNode.light = key
        keyNode.position = SCNVector3(1.5, 2, 3); scene.rootNode.addChildNode(keyNode)
        
        let rim = SCNLight(); rim.type = .omni; rim.intensity = 250
        rim.color = _PColor.white
        let rimNode = SCNNode(); rimNode.light = rim
        rimNode.position = SCNVector3(-2, 0, 1); scene.rootNode.addChildNode(rimNode)
        
        return scene
    }
    
    private func resolve(_ color: Color) -> _PColor {
        #if canImport(UIKit)
        return UIColor(color)
        #else
        return NSColor(color)
        #endif
    }
}
