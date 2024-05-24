
import Foundation
import XCTest
@testable import MagicTheGathering

final class CachedCardsRepositoryTests: XCTestCase {

    func test_repository_fetchesCardsFromRepository_whenNotSaved() async throws {
        let repository = CardsRepositorySpy()
        let sut = getSut(repository: repository)

        _ = try await sut.fetchCards()

        XCTAssertEqual(repository.fetchCards_calledTimes, 1)
    }

    func test_repository_fetchesCardsFromCache_whenSaved() async throws {
        let expectedCards = [Card(id: "", name: "Name", type: "Type", text: "Text", imageUrl: nil)]
        let repository = CardsRepositoryMock()
        repository.fetchCards_return = expectedCards
        let sut = getSut(repository: repository)

        _ = try await sut.fetchCards()
        repository.fetchCards_return = []
        let retrievedCards = try await sut.fetchCards()

        XCTAssertEqual(repository.fetchCards_calledTimes, 1)
        XCTAssertEqual(expectedCards, retrievedCards)
    }

    // MARK: - Util

    private func getSut(repository: CardsRepository) -> CachedCardsRepository {
        let cacher = Cacher<String, [Card]>()
        let sut = CachedCardsRepository(repository: repository, cacher: cacher)

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}
