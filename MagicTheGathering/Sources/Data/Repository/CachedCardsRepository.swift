
import Foundation

final class CachedCardsRepository: CardsRepository {

    private let fetchCardsKey = "fetchCards"
    private let repository: CardsRepository
    private let cacher:Cacher<String, [Card]>

    init(repository: CardsRepository, cacher: Cacher<String, [Card]>) {
        self.repository = repository
        self.cacher = cacher
    }

    func fetchCards() async throws -> [Card] {
        if let cachedCards = await cacher.getValue(for: fetchCardsKey) {
            return cachedCards
        }
        let cards = try await repository.fetchCards()
        await cacher.save(cards, for: fetchCardsKey)
        return cards
    }
}
