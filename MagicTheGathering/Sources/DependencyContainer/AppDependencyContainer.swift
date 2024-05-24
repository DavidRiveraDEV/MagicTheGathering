
import Foundation

final class AppDependencyContainer {

    static func buildApp() -> MagicTheGatheringApp {
        let router = buildCardsRouter()
        return MagicTheGatheringApp(router: router)
    }

    private static func buildCardsRouter() -> MagicCardsRouter {
        let screenBuilder = buildScreenBuilder()
        return MagicCardsRouter(screenBuilder: screenBuilder)
    }

    private static func buildScreenBuilder() -> ScreenBuilder {
        let cardsDependencyContainer = CardsScreenDependencyContainer()
        let cardDetailDependencyContainer = CardDetailScreenDependencyContainer()
        return ScreenDependencyContainer(cardsDependencyContainer: cardsDependencyContainer,
                                         cardDetailDependencyContainer: cardDetailDependencyContainer)
    }
}
