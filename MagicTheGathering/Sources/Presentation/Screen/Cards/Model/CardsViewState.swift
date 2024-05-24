
import Foundation

enum CardsViewState: Equatable {
    case loading
    case error(_ errorMessage: ErrorMessage)
    case showingCards(_ cards: [Card])
}
