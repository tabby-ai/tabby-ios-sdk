import UIKit

// MARK: - ImageCache

protocol ImageCache {
    subscript(_ data: URL) -> UIImage? { get set }
}

// MARK: - TemporaryImageCache

struct TemporaryImageCache: ImageCache {

    // MARK: - Private Properties

    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100 // 100 items
        cache.totalCostLimit = 1024 * 1024 * 50 // 50 MB
        return cache
    }()

    // MARK: - Subscript

    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set(new) {
            if let imageData = new?.pngData() {
                cache.setObject(new!, forKey: key as NSURL, cost: imageData.count)
            } else {
                cache.removeObject(forKey: key as NSURL)
            }
        }
    }
}
