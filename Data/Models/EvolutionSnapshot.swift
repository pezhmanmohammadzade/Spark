import Foundation
import SwiftData

@Model
public class EvolutionSnapshot: Identifiable {
    public var id: UUID = UUID()
    public var timestamp: Date = Date()
    public var xpSnapshot: Int = 0
    public var levelSnapshot: Int = 0
    public var totalWorkshopsCompleted: Int = 0
    
    public init(xp: Int, level: Int, completed: Int = 0) {
        self.xpSnapshot = xp
        self.levelSnapshot = level
        self.totalWorkshopsCompleted = completed
    }
}
