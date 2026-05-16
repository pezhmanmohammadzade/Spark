import SwiftUI
import SwiftData

/// 3D Trophy gallery — "Neural Armory" — showcasing unlocked achievement trophies.
public struct TrophyArmoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Trophy.unlockedAt, order: .reverse) private var trophies: [Trophy]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // All possible trophies for locked display
    private let allMilestones: [(milestone: String, name: String, hint: String, hue: Double, type: String)] = [
        ("level_5", "Ignition Core", "Reach Level 5", 0.6, "orb"),
        ("level_10", "Neural Forge", "Reach Level 10", 0.75, "prism"),
        ("level_15", "Spark Catalyst", "Reach Level 15", 0.08, "crystal"),
        ("level_20", "Void Breaker", "Reach Level 20", 0.12, "orb"),
        ("first_project", "First Spark", "Complete your first project", 0.55, "crystal"),
        ("all_workshops", "Nexus Master", "Complete all workshops", 0.55, "prism")
    ]
    
    public init() {}
    
    public var body: some View {
        ZStack {
            SparkBackground().ignoresSafeArea()
            StarFieldLayer().ignoresSafeArea().opacity(0.5)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("NEURAL ARMORY")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("\(trophies.count) ARTIFACTS UNLOCKED")
                            .font(SparkTheme.Typography.micro)
                            .foregroundColor(SparkTheme.Colors.levelGold.opacity(0.7))
                            .tracking(2)
                    }
                    
                    Spacer()
                    
                    Button(action: { HapticManager.shared.triggerSelection(); dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32, weight: .semibold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white.opacity(0.4))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                ScrollView(showsIndicators: false) {
                    if trophies.isEmpty && allMilestones.isEmpty {
                        emptyState
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            // Unlocked trophies
                            ForEach(trophies) { trophy in
                                UnlockedTrophyCard(trophy: trophy)
                            }
                            
                            // Locked trophies
                            ForEach(lockedMilestones, id: \.milestone) { m in
                                LockedTrophyCard(name: m.name, hint: m.hint, hue: m.hue)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 60)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var lockedMilestones: [(milestone: String, name: String, hint: String, hue: Double, type: String)] {
        let unlockedKeys = Set(trophies.map { $0.milestone })
        return allMilestones.filter { !unlockedKeys.contains($0.milestone) }
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 80)
            
            ZStack {
                PulsingRingView(color: .gray.opacity(0.3), baseSize: 80)
                Image(systemName: "trophy")
                    .font(.system(size: 44))
                    .foregroundColor(.gray.opacity(0.4))
            }
            
            VStack(spacing: 8) {
                Text("ARMORY EMPTY")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
                Text("Evolve to unlock your first artifact.")
                    .font(SparkTheme.Typography.body)
                    .foregroundColor(.white.opacity(0.4))
            }
            
            Spacer()
        }
    }
}

// MARK: - Unlocked Trophy Card

struct UnlockedTrophyCard: View {
    let trophy: Trophy
    @State private var glow = false
    
    var trophyColor: Color {
        Color(hue: trophy.colorHue, saturation: 0.8, brightness: 1.0)
    }
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                // 3D Trophy based on type
                ZStack {
                    PulsingRingView(color: trophyColor.opacity(0.3), baseSize: 50)
                    
                    Group {
                        switch trophy.trophyType {
                        case "prism":
                            Spark3DPrism(size: 64, color: trophyColor)
                        case "crystal":
                            Spark3DCrystal(size: 64, color: trophyColor)
                        default:
                            Spark3DOrb(size: 64, color: trophyColor)
                        }
                    }
                    .shadow(color: trophyColor.opacity(glow ? 0.6 : 0.2), radius: glow ? 16 : 8)
                }
                .frame(height: 80)
                
                VStack(spacing: 4) {
                    Text(trophy.name.uppercased())
                        .font(.system(size: 11, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(trophy.trophyDescription)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(trophy.unlockedAt.formatted(.dateTime.month().day()))
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundColor(trophyColor.opacity(0.6))
                        .padding(.top, 2)
                }
            }
        }
        .frame(minHeight: 200)
        .parallax3DTilt(maxAngle: 7)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}

// MARK: - Locked Trophy Card

struct LockedTrophyCard: View {
    let name: String
    let hint: String
    let hue: Double
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray.opacity(0.3))
                }
                .frame(height: 80)
                
                VStack(spacing: 4) {
                    Text("???")
                        .font(.system(size: 11, weight: .black, design: .rounded))
                        .foregroundColor(.gray.opacity(0.4))
                    
                    Text(hint)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.gray.opacity(0.3))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
        }
        .frame(minHeight: 200)
        .opacity(0.6)
    }
}
