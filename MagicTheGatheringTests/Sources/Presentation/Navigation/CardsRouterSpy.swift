
import Foundation
@testable import MagicTheGathering

final class CardsRouterSpy: CardsRouter {

    var navigateToCards_calledTimes = 0

    func navigateToCards() {
        navigateToCards_calledTimes += 1
    }
}
