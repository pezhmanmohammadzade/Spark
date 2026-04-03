import SwiftUI

public struct SparkBackground: View {
    public init() {}
    
    public var body: some View {
        SparkMeshBackground()
            .ignoresSafeArea()
    }
}
