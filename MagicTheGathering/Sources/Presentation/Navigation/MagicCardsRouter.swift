
import Foundation
import UIKit

final class MagicCardsRouter: CardsRouter {

    let rootViewController: UISplitViewController
    private let mainNavigationController: UINavigationController
    private let cardsRepositoryCacher = Cacher<String, [Card]>()
    private let imageCacher = Cacher<String, UIImage>()

    init() {
        rootViewController = UISplitViewController()
        rootViewController.preferredDisplayMode = .oneBesideSecondary
        mainNavigationController = UINavigationController()
        rootViewController.viewControllers = [mainNavigationController]
        navigateToMain()
    }

    func navigateToMain() {
        let mainViewController = MainViewController.instantiate(router: self)
        mainNavigationController.viewControllers = [mainViewController]
        mainViewController.willAppear = { [weak self] in
            guard let self, !self.rootViewController.isCollapsed else { return }
            self.rootViewController.show(UIViewController(), sender: nil)
        }
    }

    func navigateToCards() {
        let api = MagicCardsAPI()
        let session = Foundation.URLSession.shared
        let remoteRepository = RemoteCardsRepository(api: api, session: session)
        let cachedRepository = CachedCardsRepository(repository: remoteRepository, cacher: cardsRepositoryCacher)
        let useCase = MagicCardsUseCase(repository: cachedRepository)
        let viewModel = MagicCardsViewModel(useCase: useCase)
        let cards = MagicCardsViewController(viewModel: viewModel, router: self)
        mainNavigationController.show(cards, sender: nil)
    }

    func navigateToCardDetail(_ card: Card) {
        let imageLoader = MagicCardImageLoader()
        let chachedImageLoader = CachedUIImageLoader(imageLoader: imageLoader, cacher: imageCacher)
        let viewModel = MagicCardDetailViewModel(card: card, imageLoader: chachedImageLoader)
        let cardDetail = MagicCardDetailViewController(viewModel: viewModel)
        if self.rootViewController.isCollapsed {
            mainNavigationController.show(cardDetail, sender: nil)
        } else {
            rootViewController.show(cardDetail, sender: nil)
        }
    }
}
