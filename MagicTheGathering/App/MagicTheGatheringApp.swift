
import Foundation
import UIKit

final class MagicTheGatheringApp {

    private let router: MagicCardsRouter

    init(router: MagicCardsRouter) {
        self.router = router
    }

    func start(windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = router.rootViewController
        window.makeKeyAndVisible()
        return window
    }
}
