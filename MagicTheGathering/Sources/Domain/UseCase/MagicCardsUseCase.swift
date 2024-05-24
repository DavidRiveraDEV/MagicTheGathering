
import Foundation

final class MagicCardsUseCase: CardsUseCase {

    private let repository: CardsRepository

    init(repository: CardsRepository) {
        self.repository = repository
    }

    func fetchCards() async throws -> [Card] {
        try await repository.fetchCards()
    }
}
