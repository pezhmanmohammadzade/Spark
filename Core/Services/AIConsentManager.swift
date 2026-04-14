import Foundation
import SwiftUI

/// Manages the user's consent for third-party AI processing.
@MainActor
public final class AIConsentManager: ObservableObject {
    public static let shared = AIConsentManager()
    
    private let consentKey = "com.spark.ai.consent_granted"
    
    @Published public private(set) var hasGrantedConsent: Bool {
        didSet {
            UserDefaults.standard.set(hasGrantedConsent, forKey: consentKey)
        }
    }
    
    private init() {
        self.hasGrantedConsent = UserDefaults.standard.bool(forKey: consentKey)
    }
    
    public func grantConsent() {
        hasGrantedConsent = true
    }
    
    /// Resets consent for testing purposes if needed
    public func resetConsent() {
        hasGrantedConsent = false
    }
}
