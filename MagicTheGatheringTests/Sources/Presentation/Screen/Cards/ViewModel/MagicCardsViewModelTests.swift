
import Foundation
import XCTest
import Combine
@testable import MagicTheGathering

final class MagicCardsViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    func test_viewModel_inits_withShowingEmptyCardsState() {
        let useCase = CardsUseCaseDummy()
        let sut = getSut(useCase: useCase)

        XCTAssertEqual(sut.state, .showingCards([]))
    }

    func test_viewModel_setsErrorState_onLoadCards_withConnectionError() {
        let useCase = CardsUseCaseStub()
        useCase.error = CardsError.connection
        let sut = getSut(useCase: useCase)

        let expectation = expectation(description: "state")
        expectation.expectedFulfillmentCount = 3
        var receivedStates = [CardsViewState]()
        sut.$state.sink { state in
            receivedStates.append(state)
            expectation.fulfill()
        }.store(in: &cancellables)

        sut.loadCards()

        wait(for: [expectation], timeout: 1)

        let expectedStates: [CardsViewState] = [
            .showingCards([]),
            .loading,
            .error(.init(title: "Error", message: "Please check your internet connection and try again."))
        ]

        XCTAssertEqual(receivedStates, expectedStates)
    }

    func test_viewModel_setsErrorState_onLoadCards_withUnknownError() {
        let useCase = CardsUseCaseStub()
        useCase.error = CardsError.unknown
        let sut = getSut(useCase: useCase)

        let expectation = expectation(description: "state")
        expectation.expectedFulfillmentCount = 3
        var receivedStates = [CardsViewState]()
        sut.$state.sink { state in
            receivedStates.append(state)
            expectation.fulfill()
        }.store(in: &cancellables)

        sut.loadCards()

        wait(for: [expectation], timeout: 1)

        let expectedStates: [CardsViewState] = [
            .showingCards([]),
            .loading,
            .error(.init(title: "Error", message: "Unexpected error has occurred. Please try again."))
        ]

        XCTAssertEqual(receivedStates, expectedStates)
    }

    func test_viewModel_setsShowingCardsState_onLoadCards() {
        let useCase = CardsUseCaseStub()
        let cards = [
            Card(id: "b7c19924", name: "Card 1", type: "Type 1", text: "Text 1", imageUrl: nil),
            Card(id: "586e940bd42", name: "Card 2", type: "Type 2", text: "Text 3", imageUrl: "https://image.url/2"),
            Card(id: "56fcaa73", name: "Card 3", type: "Type 3", text: "Text 3", imageUrl: "https://image.url/3")
        ]
        useCase.cards = cards
        let sut = getSut(useCase: useCase)

        let expectation = expectation(description: "state")
        expectation.expectedFulfillmentCount = 3
        var receivedStates = [CardsViewState]()
        sut.$state.sink { state in
            receivedStates.append(state)
            expectation.fulfill()
        }.store(in: &cancellables)

        sut.loadCards()

        wait(for: [expectation], timeout: 1)

        let expectedStates: [CardsViewState] = [
            .showingCards([]),
            .loading,
            .showingCards(cards)
        ]

        XCTAssertEqual(receivedStates, expectedStates)
    }

    // MARK: - Util

    private func getSut(useCase: CardsUseCase) -> MagicCardsViewModel {
        let sut = MagicCardsViewModel(useCase: useCase)

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}
