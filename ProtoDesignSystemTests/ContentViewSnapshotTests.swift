import SwiftUI
import Testing
@testable import ProtoDesignSystem

struct ContentViewSnapshotTests {
    @MainActor
    @Test func contentView_matchesPreviewSnapshot() throws {
        let view = ContentViewPreviewFactory.makeSample()
            .frame(width: SnapshotConfiguration.default.size.width,
                   height: SnapshotConfiguration.default.size.height)

        try assertSnapshot(of: view, named: "ContentView-default")
    }
}
