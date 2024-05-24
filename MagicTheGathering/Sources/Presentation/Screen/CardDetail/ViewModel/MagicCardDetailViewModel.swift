
import Foundation
import UIKit

class MagicCardDetailViewModel: CardDetailViewModel {

    private let imageLoader: UIImageLoader

    let card: Card

    init(card: Card, imageLoader: UIImageLoader) {
        self.card = card
        self.imageLoader = imageLoader
    }

    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = card.imageUrl, let url = URL(string: imageUrl) else {
            completion(nil)
            return
        }
        Task(priority: .medium) {
            let image = await imageLoader.load(from: url)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
