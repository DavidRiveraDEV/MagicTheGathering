
import Foundation
@testable import MagicTheGathering

final class CardsRouterSpy: CardsRouter {

    var navigateToMain_calledTimes = 0
    var navigateToCards_calledTimes = 0
    var navigateToCardDetail_cards = [Card]()

    func navigateToMain() {
        navigateToMain_calledTimes += 1
    }

    func navigateToCards() {
        navigateToCards_calledTimes += 1
    }

    func navigateToCardDetail(_ card: Card) {
        navigateToCardDetail_cards.append(card)
    }
}
