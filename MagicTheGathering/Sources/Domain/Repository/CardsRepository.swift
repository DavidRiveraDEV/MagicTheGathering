
import Foundation

protocol CardsRepository {

    func fetchCards() async throws -> [Card]
}
