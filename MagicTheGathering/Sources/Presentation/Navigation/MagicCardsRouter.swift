
import Foundation
import UIKit

final class MagicCardsRouter: CardsRouter {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigateToMain() {
        let main = MainViewController.instantiate(router: self)
        navigationController.show(main, sender: nil)
    }

    func navigateToCards() {
        let api = MagicCardsAPI()
        let session = Foundation.URLSession.shared
        let repository = RemoteCardsRepository(api: api, session: session)
        let useCase = MagicCardsUseCase(repository: repository)
        let viewModel = MagicCardsViewModel(useCase: useCase)
        let cards = MagicCardsViewController(viewModel: viewModel, router: self)
        navigationController.show(cards, sender: nil)
    }

    func navigateToCardDetail(_ card: Card) {
        let imageLoader = MagicCardImageLoader()
        let viewModel = MagicCardDetailViewModel(card: card, imageLoader: imageLoader)
        let cardDetail = MagicCardDetailViewController(viewModel: viewModel)
        navigationController.show(cardDetail, sender: nil)
    }
}
