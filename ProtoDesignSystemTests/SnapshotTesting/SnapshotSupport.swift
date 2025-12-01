import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import Testing

private let snapshotDefaultScale: CGFloat = {
#if canImport(UIKit)
    UIScreen.main.scale
#else
    2
#endif
}()

struct SnapshotConfiguration: Sendable, Hashable {
    var size: CGSize = CGSize(width: 390, height: 844) // iPhone 15 Pro logical size
    var colorScheme: ColorScheme = .light
    var scale: CGFloat = snapshotDefaultScale

    static let `default` = SnapshotConfiguration()
}

enum SnapshotError: Error {
    case rendererUnavailable
    case missingReference(URL)
}

@MainActor
func assertSnapshot<V: View>(
    of view: V,
    named name: String,
    configuration: SnapshotConfiguration = .default,
    filePath: StaticString = #filePath,
    fileID: StaticString = #fileID,
    line: UInt = #line
) throws {
    #if !canImport(UIKit)
    Issue.record("Snapshot tests currently require UIKit")
    return
    #else
    let renderer = ImageRenderer(content: view.environment(\.colorScheme, configuration.colorScheme))
    renderer.scale = configuration.scale
    renderer.proposedSize = .init(configuration.size)

    guard let image = renderer.uiImage else {
        throw SnapshotError.rendererUnavailable
    }

    let pngData = image.pngData() ?? Data()
    let snapshotDirectory = snapshotsDirectory(for: fileID)
    let referenceURL = snapshotDirectory.appendingPathComponent("\(name).png")

    if !FileManager.default.fileExists(atPath: referenceURL.path) {
        try FileManager.default.createDirectory(at: snapshotDirectory, withIntermediateDirectories: true)
        try pngData.write(to: referenceURL)
        #expect(false, "Snapshot reference was missing. A new reference was recorded at \(referenceURL.path). Please verify and re-run the tests.", file: filePath, line: line)
        return
    }

    let referenceData = try Data(contentsOf: referenceURL)
    #expect(referenceData == pngData, "Snapshot does not match reference for \(name).", file: filePath, line: line)
    #endif
}

private func snapshotsDirectory(for fileID: StaticString) -> URL {
    let testFileURL = URL(fileURLWithPath: String(describing: fileID))
    return testFileURL.deletingLastPathComponent().appendingPathComponent("__Snapshots__", isDirectory: true)
}
