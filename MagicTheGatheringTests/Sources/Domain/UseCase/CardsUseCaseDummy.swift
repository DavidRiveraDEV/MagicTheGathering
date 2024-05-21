
import Foundation
@testable import MagicTheGathering

struct CardsUseCaseDummy: CardsUseCase {

    func fetchCards() async throws -> [Card] { [] }
}
