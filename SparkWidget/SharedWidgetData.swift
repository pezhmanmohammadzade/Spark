import Foundation
import WidgetKit

/// Lightweight bridge for sharing data between the main Spark app and widget extension
/// via a shared App Group UserDefaults suite.
public struct SharedWidgetData {
    
    public static let suiteName = "group.com.spark.app.concept"
    
    // MARK: - Keys
    private enum Keys {
        static let level = "widget_level"
        static let levelTitle = "widget_levelTitle"
        static let currentXP = "widget_currentXP"
        static let xpForNextLevel = "widget_xpForNextLevel"
        static let dailyStreak = "widget_dailyStreak"
        static let streakMultiplier = "widget_streakMultiplier"
        static let neuralShields = "widget_neuralShields"
        static let activeProjectTitle = "widget_activeProjectTitle"
        static let activeProjectPhase = "widget_activeProjectPhase"
        static let completedSteps = "widget_completedSteps"
        static let totalSteps = "widget_totalSteps"
        static let sparkQuote = "widget_sparkQuote"
        static let dailyChallenge = "widget_dailyChallenge"
    }
    
    // MARK: - Write (Main App → UserDefaults)
    
    public static func syncStats(
        level: Int,
        levelTitle: String,
        currentXP: Int,
        xpForNextLevel: Int,
        dailyStreak: Int,
        streakMultiplier: Double,
        neuralShields: Int
    ) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        defaults.set(level, forKey: Keys.level)
        defaults.set(levelTitle, forKey: Keys.levelTitle)
        defaults.set(currentXP, forKey: Keys.currentXP)
        defaults.set(xpForNextLevel, forKey: Keys.xpForNextLevel)
        defaults.set(dailyStreak, forKey: Keys.dailyStreak)
        defaults.set(streakMultiplier, forKey: Keys.streakMultiplier)
        defaults.set(neuralShields, forKey: Keys.neuralShields)
    }
    
    public static func syncProject(
        title: String?,
        phase: String?,
        completedSteps: Int,
        totalSteps: Int
    ) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        defaults.set(title, forKey: Keys.activeProjectTitle)
        defaults.set(phase, forKey: Keys.activeProjectPhase)
        defaults.set(completedSteps, forKey: Keys.completedSteps)
        defaults.set(totalSteps, forKey: Keys.totalSteps)
    }
    
    public static func syncQuote(_ quote: String) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        defaults.set(quote, forKey: Keys.sparkQuote)
    }
    
    public static func syncChallenge(_ challenge: String) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        defaults.set(challenge, forKey: Keys.dailyChallenge)
    }
    
    // MARK: - Read (Widget ← UserDefaults)
    
    public static var level: Int {
        UserDefaults(suiteName: suiteName)?.integer(forKey: Keys.level) ?? 1
    }
    
    public static var levelTitle: String {
        UserDefaults(suiteName: suiteName)?.string(forKey: Keys.levelTitle) ?? "Novice Explorer"
    }
    
    public static var currentXP: Int {
        UserDefaults(suiteName: suiteName)?.integer(forKey: Keys.currentXP) ?? 0
    }
    
    public static var xpForNextLevel: Int {
        let val = UserDefaults(suiteName: suiteName)?.integer(forKey: Keys.xpForNextLevel) ?? 1000
        return max(val, 1)
    }
    
    public static var dailyStreak: Int {
        UserDefaults(suiteName: suiteName)?.integer(forKey: Keys.dailyStreak) ?? 0
    }
    
    public static var streakMultiplier: Double {
        UserDefaults(suiteName: suiteName)?.double(forKey: Keys.streakMultiplier) ?? 1.0
    }
    
    public static var neuralShields: Int {
        UserDefaults(suiteName: suiteName)?.integer(forKey: Keys.neuralShields) ?? 0
    }
    
    public static var activeProjectTitle: String? {
        UserDefaults(suiteName: suiteName)?.string(forKey: Keys.activeProjectTitle)
    }
    
    public static var activeProjectPhase: String? {
        UserDefaults(suiteName: suiteName)?.string(forKey: Keys.activeProjectPhase)
    }
    
    public static var completedSteps: Int {
        UserDefaults(suiteName: suiteName)?.integer(forKey: Keys.completedSteps) ?? 0
    }
    
    public static var totalSteps: Int {
        let val = UserDefaults(suiteName: suiteName)?.integer(forKey: Keys.totalSteps) ?? 0
        return max(val, 1)
    }
    
    public static var sparkQuote: String {
        UserDefaults(suiteName: suiteName)?.string(forKey: Keys.sparkQuote) ?? "● SPARK ONLINE: READY TO CHALLENGE YOUR STRATEGY."
    }
    
    public static var dailyChallenge: String {
        UserDefaults(suiteName: suiteName)?.string(forKey: Keys.dailyChallenge) ?? "THE BIG IDEA IS STILL VAGUE. IF NO ONE USES THIS TOMORROW, WHOSE LIFE IS MOST MISERABLE?"
    }
    
    // MARK: - Refresh Widgets
    
    public static func reloadWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
