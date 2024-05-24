
import Foundation
@testable import MagicTheGathering

final class CardsRepositorySpy: CardsRepository {

    var fetchCards_calledTimes = 0

    func fetchCards() async throws -> [Card] {
        fetchCards_calledTimes += 1
        return []
    }
}
