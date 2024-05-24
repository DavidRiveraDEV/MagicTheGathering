
import Foundation
import UIKit
@testable import MagicTheGathering

final class UIImageLoaderSpy: UIImageLoader {

    var loadFrom_urls = [URL]()

    func load(from url: URL) async -> UIImage? {
        loadFrom_urls.append(url)
        return nil
    }
}
