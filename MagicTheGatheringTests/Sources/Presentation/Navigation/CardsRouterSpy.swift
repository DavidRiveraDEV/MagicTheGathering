
import Foundation
@testable import MagicTheGathering

final class CardsRouterSpy: CardsRouter {

    var navigateToCards_calledTimes = 0
    var navigateToCardDetail_cards = [Card]()

    func navigateToCards() {
        navigateToCards_calledTimes += 1
    }

    func navigateToCardDetail(_ card: Card) {
        navigateToCardDetail_cards.append(card)
    }
}
