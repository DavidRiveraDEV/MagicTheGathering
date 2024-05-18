
import Foundation

protocol CardsUseCase {

    func fetchCards() async throws -> [Card]
}
