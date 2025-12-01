import SwiftData
import SwiftUI

// A shared Preview factory so tests and design-time previews render the same view hierarchy.
enum ContentViewPreviewFactory {
    @MainActor
    static func makeSample() -> some View {
        ContentView()
            .modelContainer(for: Item.self, inMemory: true)
    }
}

#Preview {
    ContentViewPreviewFactory.makeSample()
}
