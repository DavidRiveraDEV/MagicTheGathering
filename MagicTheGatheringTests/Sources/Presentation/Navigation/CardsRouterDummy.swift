import Foundation
@testable import MagicTheGathering

final class CardsRouterDummy: CardsRouter {

    func navigateToMain() {}

    func navigateToCards() {}

    func navigateToCardDetail(_ card: Card) {}
}
