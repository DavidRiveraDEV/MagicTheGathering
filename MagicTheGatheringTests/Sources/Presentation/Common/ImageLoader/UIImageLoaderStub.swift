
import Foundation
import UIKit
@testable import MagicTheGathering

final class UIImageLoaderStub: UIImageLoader {

    var image: UIImage?

    func load(from url: URL) async -> UIImage? {
        return image
    }
}
