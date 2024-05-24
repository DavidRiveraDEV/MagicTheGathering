
import Foundation
import UIKit

final class CachedUIImageLoader: UIImageLoader {

    private let imageLoader: UIImageLoader
    private let cacher: Cacher<String, UIImage>

    init(imageLoader: UIImageLoader, cacher: Cacher<String, UIImage>) {
        self.imageLoader = imageLoader
        self.cacher = cacher
    }

    func load(from url: URL) async -> UIImage? {
        let key = url.absoluteString
        if let cachedImage = await cacher.getValue(for: key) {
            return cachedImage
        }
        guard let image = await imageLoader.load(from: url) else { return nil }
        await cacher.save(image, for: key)
        return image
    }
}
