
import Foundation
import UIKit

final class App {

    private let navigationController = UINavigationController()
    private let router: CardsRouter

    init() {
        router = MagicCardsRouter(navigationController: navigationController)
    }

    func start(windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        router.navigateToMain()
        return window
    }
}
