
import Foundation

struct MainScreenDependencyContainer {

    static func buildMainViewController(router: CardsRouter, willAppear: (() -> Void)?) -> MainViewController {
        let mainViewController = MainViewController.instantiate(router: router)
        mainViewController.willAppear = willAppear
        return mainViewController
    }
}
