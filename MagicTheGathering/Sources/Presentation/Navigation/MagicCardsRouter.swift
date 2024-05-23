
import Foundation
import UIKit

final class MagicCardsRouter: CardsRouter {

    let rootViewController: UISplitViewController
    let mainNavigationController: UINavigationController

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
        let repository = RemoteCardsRepository(api: api, session: session)
        let useCase = MagicCardsUseCase(repository: repository)
        let viewModel = MagicCardsViewModel(useCase: useCase)
        let cards = MagicCardsViewController(viewModel: viewModel, router: self)
        mainNavigationController.show(cards, sender: nil)
    }

    func navigateToCardDetail(_ card: Card) {
        let imageLoader = MagicCardImageLoader()
        let viewModel = MagicCardDetailViewModel(card: card, imageLoader: imageLoader)
        let cardDetail = MagicCardDetailViewController(viewModel: viewModel)
        if self.rootViewController.isCollapsed {
            mainNavigationController.show(cardDetail, sender: nil)
        } else {
            rootViewController.show(cardDetail, sender: nil)
        }
    }
}
