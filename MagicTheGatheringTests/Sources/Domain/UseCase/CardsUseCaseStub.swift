
import Foundation
@testable import MagicTheGathering

final class CardsUseCaseStub: CardsUseCase {

    var error: Error?
    var cards: [Card]?

    func fetchCards() async throws -> [Card] {
        guard let cards else {
            throw error ?? CardsError.unknown
        }
        return cards
    }
}
