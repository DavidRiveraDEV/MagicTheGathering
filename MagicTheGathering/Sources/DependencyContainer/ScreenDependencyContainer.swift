
import Foundation
import UIKit

final class ScreenDependencyContainer: ScreenBuilder {

    private let cardsDependencyContainer: CardsScreenDependencyContainer
    private let cardDetailDependencyContainer: CardDetailScreenDependencyContainer

    init(cardsDependencyContainer: CardsScreenDependencyContainer, 
         cardDetailDependencyContainer: CardDetailScreenDependencyContainer) {
        self.cardsDependencyContainer = cardsDependencyContainer
        self.cardDetailDependencyContainer = cardDetailDependencyContainer
    }

    func buildMainViewController(router: CardsRouter, willAppear: (() -> Void)?) -> MainViewController {
        return MainScreenDependencyContainer.buildMainViewController(router: router, willAppear: willAppear)
    }
    
    func buildMagicCardsViewController(router: CardsRouter) -> MagicCardsViewController {
        return cardsDependencyContainer.buildMagicCardsViewController(router: router)
    }

    func buildMagicCardDetailViewController(card: Card) -> MagicCardDetailViewController {
        return cardDetailDependencyContainer.buildMagicCardDetailViewController(card: card)
    }
}
