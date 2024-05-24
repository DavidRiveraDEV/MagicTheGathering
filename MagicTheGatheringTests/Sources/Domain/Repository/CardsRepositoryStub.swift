
import Foundation
@testable import MagicTheGathering

final class CardsRepositoryStub: CardsRepository {

    var error: CardsError?
    var cards: [Card]?

    func fetchCards() async throws -> [Card] {
        guard let cards else {
            throw error ?? .unknown
        }
        return cards
    }
}
