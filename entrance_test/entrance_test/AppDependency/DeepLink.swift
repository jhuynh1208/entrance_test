import Foundation

/// A struct describing the deep link structure
struct DeepLink: Equatable {
    // MARK: - Enumerators

    /// Represents the deep link targets
    enum Target: Equatable {
        case sampleTarget(value: Int)
    }

    // MARK: - Properties

    /// An original url of a deep link.
    let url: URL?
    /// A target of a deep link.
    let target: Target

    // MARK: - Initialization

    init?(url: URL) {
        let mainPath = url.deletingLastPathComponent().path
        
        switch mainPath {
        case "/sample":
            self.target = .sampleTarget(value: 0)
        default:
            return nil
        }

        self.url = url
    }

    init(target: Target) {
        self.url = nil
        self.target = target
    }
}
