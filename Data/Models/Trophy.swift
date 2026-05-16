import Foundation
import SwiftData

@Model
public class Trophy: Identifiable {
    public var id: UUID = UUID()
    
    /// Display name (e.g. "Ignition Core", "Neural Forge")
    public var name: String = ""
    
    /// Flavor text describing the achievement
    public var trophyDescription: String = ""
    
    /// SF Symbol name for 2D fallback display
    public var iconSystemName: String = "trophy.fill"
    
    /// Which 3D component to render: "orb", "prism", or "crystal"
    public var trophyType: String = "orb"
    
    /// HSB hue value (0.0–1.0) used to color the 3D model
    public var colorHue: Double = 0.6
    
    /// When the trophy was unlocked
    public var unlockedAt: Date = Date()
    
    /// Unique key identifying the milestone (e.g. "level_5", "first_project")
    /// Prevents duplicate minting.
    public var milestone: String = ""
    
    public init(
        name: String,
        description: String,
        icon: String = "trophy.fill",
        type: String = "orb",
        hue: Double = 0.6,
        milestone: String
    ) {
        self.name = name
        self.trophyDescription = description
        self.iconSystemName = icon
        self.trophyType = type
        self.colorHue = hue
        self.milestone = milestone
    }
}
