
import Foundation
import UIKit

protocol CardDetailViewModel {

    var card: Card { get }

    func loadImage(completion: @escaping (UIImage?) -> Void)
}
