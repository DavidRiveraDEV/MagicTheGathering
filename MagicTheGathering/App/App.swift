
import Foundation
import UIKit

final class App {

    private let router = MagicCardsRouter()
    
    func start(windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = router.rootViewController
        window.makeKeyAndVisible()
        return window
    }
}
