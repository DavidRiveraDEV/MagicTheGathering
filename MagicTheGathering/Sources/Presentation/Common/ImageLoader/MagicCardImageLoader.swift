
import Foundation
import UIKit

final class MagicCardImageLoader: UIImageLoader {

    func load(from url: URL) async -> UIImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}
