
import Foundation
import UIKit

final class AppDependencyContainer {

    private lazy var router: MagicCardsRouter = {
        return buildCardsRouter()
    }()

    var rootViewController: UIViewController {
        router.rootViewController
    }

    private func buildCardsRouter() -> MagicCardsRouter {
        let screenBuilder = buildScreenBuilder()
        return MagicCardsRouter(screenBuilder: screenBuilder)
    }

    private func buildScreenBuilder() -> ScreenBuilder {
        let cardsDependencyContainer = CardsScreenDependencyContainer()
        let cardDetailDependencyContainer = CardDetailScreenDependencyContainer()
        return ScreenDependencyContainer(cardsDependencyContainer: cardsDependencyContainer,
                                         cardDetailDependencyContainer: cardDetailDependencyContainer)
    }
}
