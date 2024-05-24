
import Foundation
import UIKit
@testable import MagicTheGathering

final class UIImageLoaderMock: UIImageLoader {

    var loadFrom_urls = [URL]()
    var loadFrom_return: UIImage?

    func load(from url: URL) async -> UIImage? {
        loadFrom_urls.append(url)
        return loadFrom_return
    }
}
