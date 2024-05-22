
import Foundation
import XCTest
@testable import MagicTheGathering

final class MagicCardDetailViewModelTests: XCTestCase {

    func test_viewModel_setsCard() {
        let card = Card(id: "98e0jf8", name: "My card", type: "My tipe", text: "My text", imageUrl: "http://image.url")
        let sut = getSut(card: card)

        XCTAssertEqual(sut.card, card)
    }

    // MARK: - Util

    private func getSut(card: Card) -> MagicCardDetailViewModel {
        let sut = MagicCardDetailViewModel(card: card)

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}
