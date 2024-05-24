
import Foundation
@testable import MagicTheGathering

final class CardsViewModelSpy: MagicCardsViewModel {

    var loadCards_calledTimes = 0

    init() {
        super.init(useCase: CardsUseCaseDummy())
    }

    override func loadCards() {
        loadCards_calledTimes += 1
    }
}
