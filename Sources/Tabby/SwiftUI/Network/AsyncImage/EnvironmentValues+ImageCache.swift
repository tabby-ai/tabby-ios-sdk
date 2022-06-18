import SwiftUI

// MARK: - ImageCacheKey

struct ImageCacheKey: EnvironmentKey {

    // MARK: - Static Properties

    static let defaultValue: ImageCache = TemporaryImageCache()
}

// MARK: - EnvironmentValues ()

extension EnvironmentValues {

    // MARK: - Internal Properties

    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
