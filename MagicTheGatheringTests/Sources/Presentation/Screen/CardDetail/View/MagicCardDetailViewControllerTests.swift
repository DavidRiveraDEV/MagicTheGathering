
import Foundation
import XCTest
import UIKit
@testable import MagicTheGathering

final class MagicCardDetailViewControllerTests: XCTestCase {

    func test_viewController_displaysCardInformation() {
        let card = Card(id: "84nf93owss", name: "My name", type: "My type", text: "My text", imageUrl: "https://image.url")
        let imageLoader = UIImageLoaderStub()
        let expectedImage = UIImage(systemName: "person")
        imageLoader.image = expectedImage
        let viewModel = MagicCardDetailViewModel(card: card, imageLoader: imageLoader)
        let sut = getSut(viewModel: viewModel)

        _ = sut.view

        let expectation = expectation(description: "card expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(sut.nameLabel.text, card.name)
        XCTAssertEqual(sut.typeLabel.text, card.type)
        XCTAssertEqual(sut.textLabel.text, card.text)
        XCTAssertEqual(sut.imageView.image, expectedImage)
    }

    func test_viewController_doesNotDisplaysImage_whenNoImage() {
        let card = Card(id: "84nf93owss", name: "My name", type: "My type", text: "My text", imageUrl: nil)
        let viewModel = MagicCardDetailViewModel(card: card, imageLoader: MagicCardImageLoader())
        let sut = getSut(viewModel: viewModel)

        _ = sut.view

        let expectation = expectation(description: "card expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        XCTAssertNil(sut.imageView.image)
    }

    func test_viewController_displaysDefaultImage_withErrorOnLoading() {
        let card = Card(id: "84nf93owss", name: "My name", type: "My type", text: "My text", imageUrl: "https://image.url")
        let imageLoader = UIImageLoaderStub()
        imageLoader.image = nil
        let viewModel = MagicCardDetailViewModel(card: card, imageLoader: imageLoader)
        let sut = getSut(viewModel: viewModel)

        _ = sut.view

        let expectation = expectation(description: "card expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        XCTAssertNil(sut.imageView.image)
    }

    // MARK: - Util

    private func getSut(viewModel: CardDetailViewModel) -> MagicCardDetailViewController {
        let sut = MagicCardDetailViewController(viewModel: viewModel)

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}
