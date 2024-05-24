
import Foundation
@testable import MagicTheGathering

final class CardsRepositoryMock: CardsRepository {

    var fetchCards_return: [Card]?
    var fetchCards_error: Error?
    var fetchCards_calledTimes = 0

    func fetchCards() async throws -> [Card] {
        fetchCards_calledTimes += 1
        guard let fetchCards_return else {
            throw fetchCards_error ?? CardsError.unknown
        }
        return fetchCards_return
    }
}
