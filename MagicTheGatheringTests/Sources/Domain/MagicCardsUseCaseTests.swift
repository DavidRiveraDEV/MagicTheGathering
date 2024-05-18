
import Foundation
import XCTest

final class MagicCardsUseCaseTests: XCTestCase {

    func test_useCase_fetchsCards_withConnectionError() async {
        let repository = CardsRepositoryStub()
        repository.error = .connection
        let sut = getSut(repository: repository)

        do {
            _ = try await sut.fetchCards()
            XCTFail("Expected connection error")
        } catch {
            XCTAssertEqual(error as? CardsUseCaseError, .connection)
        }
    }

    func test_useCase_fetchsCards_withUnknownError() async {
        let repository = CardsRepositoryStub()
        repository.error = .unknown
        let sut = getSut(repository: repository)

        do {
            _ = try await sut.fetchCards()
            XCTFail("Expected connection error")
        } catch {
            XCTAssertEqual(error as? CardsUseCaseError, .unknown)
        }
    }

    func test_useCase_fetchsCards() async throws {
        let repository = CardsRepositoryStub()
        repository.cards = [
            .init(id: "b7c19924", name: "Card 1", type: "Type 1", text: "Text 1", imageUrl: nil),
            .init(id: "586e940bd42", name: "Card 2", type: "Type 2", text: "Text 3", imageUrl: "https://image.url/2"),
            .init(id: "56fcaa73", name: "Card 3", type: "Type 3", text: "Text 3", imageUrl: "https://image.url/3")
        ]
        let sut = getSut(repository: repository)

        let cards = try await sut.fetchCards()
        XCTAssertEqual(cards, repository.cards)
    }

    // MARK: - Util

    private func getSut(repository: CardsRepository) -> MagicCardsUseCase {
        let sut = MagicCardsUseCase(repository: repository)

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}

// impl

struct Card: Equatable {

    let id: String
    let name: String
    let type: String
    let text: String
    let imageUrl: String?
}

protocol CardsRepository {

    func fetchCards() async throws -> [Card]
}

protocol CardsUseCase {

    func fetchCards() async throws -> [Card]
}

final class MagicCardsUseCase: CardsUseCase {

    private let repository: CardsRepository

    init(repository: CardsRepository) {
        self.repository = repository
    }

    func fetchCards() async throws -> [Card] {
        try await repository.fetchCards()
    }
}

enum CardsUseCaseError: Error {
    case connection
    case unknown
}


// doubles

final class CardsRepositoryStub: CardsRepository {

    var error: CardsUseCaseError?
    var cards: [Card]?

    func fetchCards() async throws -> [Card] {
        guard let cards else {
            throw error ?? .unknown
        }
        return cards
    }
}
