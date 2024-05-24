
import Foundation
import Combine

class MagicCardsViewModel: CardsViewModel {

    @Published private(set) var state: CardsViewState

    private let useCase: CardsUseCase

    init(useCase: CardsUseCase) {
        self.useCase = useCase
        state = .showingCards([])
    }

    func loadCards() {
        state = .loading
        Task(priority: .userInitiated) {
            do {
                let cards = try await useCase.fetchCards()
                state = .showingCards(cards)
            } catch {
                handle(error: error)
            }
        }
    }

    private func handle(error: Error) {
        let error = error as? CardsError ?? .unknown
        let errorMessage = getErrorMessage(from: error)
        state = .error(errorMessage)
    }

    private func getErrorMessage(from error: CardsError) -> ErrorMessage {
        return switch error {
        case .connection: .init(title: "Error", message: "Please check your internet connection and try again.")
        case .unknown: .init(title: "Error", message: "Unexpected error has occurred. Please try again.")
        }
    }
}
