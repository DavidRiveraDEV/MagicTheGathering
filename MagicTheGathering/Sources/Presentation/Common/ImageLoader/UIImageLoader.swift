
import Foundation
import UIKit

protocol UIImageLoader {

    func load(from url: URL) async -> UIImage?
}
