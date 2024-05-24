
import Foundation
import UIKit
@testable import MagicTheGathering

final class UIImageLoaderDummy: UIImageLoader {

    func load(from url: URL) async -> UIImage? {
        return nil
    }
}
