import SwiftUI
import SceneKit

#if canImport(UIKit)
import UIKit
typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
typealias PlatformColor = NSColor
#endif

/// A high-fidelity 3D splash screen visualizing the CBL Canvas pathway.
/// This view is designed to be the entry point of the Spark experience.
public struct SparkSplashScreenView: View {
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 1.0
    @State private var logIndex: Int = 0
    @State private var visibleLogs: [String] = []
    @State private var showBranding = false
    
    private let sparkLogs = [
        "● [SYSTEM] Establishing Neural Link...",
        "● [MEM] Syncing inspiration satellites...",
        "● [CPU] Bypassing \"I'll do it tomorrow\" modules...",
        "● [NET] Fetching espresso for algorithms...",
        "● [WARN] CPU lactose intolerant... switching to Electrons.",
        "● [UI] Rendering creative potential... 100%",
        "● [OK] Spark Core Awakened."
    ]
    
    public var onFinished: () -> Void
    
    public init(onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
    }
    
    public var body: some View {
        ZStack {
            SparkBackground()
            
            // ELITE 3D SCENE: The Spark Awakening
            SceneView(
                scene: createAwakeningScene(),
                pointOfView: nil,
                options: [.autoenablesDefaultLighting, .allowsCameraControl],
                preferredFramesPerSecond: 60
            )
            .edgesIgnoringSafeArea(.all)
            .opacity(opacity)
            
            // Spark Terminal Overlay (Glass-morphism)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle().fill(.green).frame(width: 8, height: 8)
                    Text("SPARK_OS v4.0.2")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.bottom, 4)
                
                ForEach(visibleLogs, id: \.self) { log in
                    Text(log)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(log.contains("OK") ? .green : (log.contains("WARN") ? .orange : .white.opacity(0.7)))
                        .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .opacity))
                }
                Spacer()
            }
            .padding(30)
            .padding(.top, 40)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(colors: [.black.opacity(0.4), .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
            )
            
            // Final Branding Reveal
            if showBranding {
                VStack(spacing: 8) {
                    Text("SPARK")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(18)
                        .shadow(color: SparkTheme.Colors.xpElectric.opacity(0.5), radius: 30)
                    
                    Text("THE SPARK OF CREATIVITY")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(4)
                }
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .onAppear {
            runCinematicSequence()
        }
    }
    
    private func runCinematicSequence() {
        // 1. Log Deployment
        for i in 0..<sparkLogs.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    visibleLogs.append(sparkLogs[i])
                    if visibleLogs.count > 5 { visibleLogs.removeFirst() }
                }
            }
        }
        
        // 2. Branding Reveal
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            withAnimation(.easeOut(duration: 1.5)) {
                showBranding = true
            }
        }
        
        // 3. Exit Sequence
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
            withAnimation(.easeInOut(duration: 1.5)) {
                opacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onFinished()
            }
        }
    }
    
    // MARK: - Elite 3D Scene Construction
    
    private func createAwakeningScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = PlatformColor.clear
        
        // 1. THE SPARK PERSONA (Central Core)
        let coreNode = SCNNode()
        
        // Outer Shell: Crystal Wireframe
        let shellGeo = SCNSphere(radius: 1.2)
        shellGeo.segmentCount = 6
        let shellMat = SCNMaterial()
        shellMat.fillMode = .lines
        shellMat.diffuse.contents = PlatformColor.white.withAlphaComponent(0.2)
        shellMat.emission.contents = PlatformColor(red: 0.1, green: 0.4, blue: 1.0, alpha: 1.0)
        shellGeo.materials = [shellMat]
        let shellNode = SCNNode(geometry: shellGeo)
        coreNode.addChildNode(shellNode)
        
        // Inner Heart: Glowing Sphere
        let heartGeo = SCNSphere(radius: 0.4)
        let heartMat = SCNMaterial()
        heartMat.lightingModel = .physicallyBased
        heartMat.metalness.contents = 1.0
        heartMat.roughness.contents = 0.1
        heartMat.diffuse.contents = PlatformColor.black
        heartMat.emission.contents = PlatformColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1.0)
        heartGeo.materials = [heartMat]
        let heartNode = SCNNode(geometry: heartGeo)
        coreNode.addChildNode(heartNode)
        
        scene.rootNode.addChildNode(coreNode)
        
        // Core Animations
        coreNode.runAction(.repeatForever(.rotateBy(x: 0.5, y: 1.0, z: 0.3, duration: 5.0)))
        heartNode.runAction(.repeatForever(.sequence([
            .scale(to: 1.4, duration: 1.0),
            .scale(to: 1.0, duration: 1.0)
        ])))
        
        // 2. ORBITAL DATA NODES (CBL Canvas Representation)
        let colors: [PlatformColor] = [
            PlatformColor(red: 0.2, green: 0.8, blue: 1.0, alpha: 1.0), // Engage
            PlatformColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0), // Investigate
            PlatformColor(red: 1.0, green: 0.3, blue: 0.6, alpha: 1.0)  // Act
        ]
        
        for i in 0..<12 {
            let orbitNode = SCNNode()
            let angle = Float(i) * (.pi * 2 / 12)
            let radius: Float = 4.0
            
            let nodeGeo = SCNSphere(radius: 0.15)
            let nodeMat = SCNMaterial()
            let color = colors[i % 3]
            nodeMat.diffuse.contents = color
            nodeMat.emission.contents = color.withAlphaComponent(0.5)
            nodeGeo.materials = [nodeMat]
            
            let node = SCNNode(geometry: nodeGeo)
            node.position = SCNVector3(cos(angle) * radius, sin(angle) * radius, Float(i - 6) * 0.5)
            orbitNode.addChildNode(node)
            
            // Connection Line to Core
            let line = SCNCylinder(radius: 0.01, height: CGFloat(radius))
            let lineMat = SCNMaterial()
            lineMat.diffuse.contents = color.withAlphaComponent(0.1)
            lineMat.emission.contents = color.withAlphaComponent(0.2)
            line.materials = [lineMat]
            let lineNode = SCNNode(geometry: line)
            lineNode.position = SCNVector3(cos(angle) * radius * 0.5, sin(angle) * radius * 0.5, 0)
            lineNode.eulerAngles.z = angle + .pi/2
            orbitNode.addChildNode(lineNode)
            
            scene.rootNode.addChildNode(orbitNode)
            orbitNode.runAction(.repeatForever(.rotateBy(x: 0, y: 0, z: 1.0, duration: Double.random(in: 10...20))))
        }
        
        // 3. MODERN LIGHTING
        let spotLight = SCNLight()
        spotLight.type = .spot
        spotLight.intensity = 2000
        spotLight.color = PlatformColor.white
        spotLight.spotInnerAngle = 30
        spotLight.spotOuterAngle = 80
        let spotNode = SCNNode()
        spotNode.light = spotLight
        spotNode.position = SCNVector3(5, 5, 15)
        spotNode.constraints = [SCNLookAtConstraint(target: coreNode)]
        scene.rootNode.addChildNode(spotNode)
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 100
        ambientLight.color = PlatformColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        scene.rootNode.addChildNode(ambientNode)
        
        // 4. CINEMATIC CAMERA SYSTEM
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 60
        cameraNode.camera?.motionBlurIntensity = 1.0
        cameraNode.position = SCNVector3(0, 0, 0.5) // Start inside/close
        scene.rootNode.addChildNode(cameraNode)
        
        // Camera Fly-through Sequence
        let flyAction = SCNAction.sequence([
            .wait(duration: 0.5),
            .move(to: SCNVector3(0, 0, 15), duration: 4.0), // Smooth pull back
            .rotateBy(x: 0, y: 0, z: .pi / 4, duration: 2.0)
        ])
        flyAction.timingMode = .easeInEaseOut
        cameraNode.runAction(flyAction)
        
        return scene
    }
}
