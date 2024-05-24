
import Foundation
import UIKit

final class CardDetailScreenDependencyContainer {

    private let imageCacher = Cacher<String, UIImage>()

    func buildMagicCardDetailViewController(card: Card) -> MagicCardDetailViewController {
        let viewModel = buildViewModel(card: card)
        return .init(viewModel: viewModel)
    }

    private func buildViewModel(card: Card) -> MagicCardDetailViewModel {
        let imageLoader = buildImageLoader()
        return .init(card: card, imageLoader: imageLoader)
    }

    private func buildImageLoader() -> UIImageLoader {
        let imageLoader = MagicCardImageLoader()
        return  CachedUIImageLoader(imageLoader: imageLoader, cacher: imageCacher)
    }
}
