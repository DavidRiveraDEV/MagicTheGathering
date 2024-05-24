
import Foundation
import UIKit

final class MagicCardsRouter: CardsRouter {

    private let screenBuilder: ScreenBuilder
    let rootViewController = UISplitViewController()
    private let mainNavigationController = UINavigationController()

    init(screenBuilder: ScreenBuilder) {
        self.screenBuilder = screenBuilder
        rootViewController.preferredDisplayMode = .oneBesideSecondary
        rootViewController.viewControllers = [mainNavigationController]
        navigateToMain()
    }

    func navigateToMain() {
        let mainViewController = screenBuilder.buildMainViewController(router: self) { [weak self] in
            guard let self, !self.rootViewController.isCollapsed else { return }
            self.rootViewController.show(UIViewController(), sender: nil)
        }
        mainNavigationController.viewControllers = [mainViewController]
    }

    func navigateToCards() {
        let cardsViewController = screenBuilder.buildMagicCardsViewController(router: self)
        mainNavigationController.show(cardsViewController, sender: nil)
    }

    func navigateToCardDetail(_ card: Card) {
        let cardDetailViewController = screenBuilder.buildMagicCardDetailViewController(card: card)
        if self.rootViewController.isCollapsed {
            mainNavigationController.show(cardDetailViewController, sender: nil)
        } else {
            rootViewController.show(cardDetailViewController, sender: nil)
        }
    }
}
