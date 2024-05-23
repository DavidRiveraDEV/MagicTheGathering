
import Foundation
import XCTest
import UIKit
@testable import MagicTheGathering

final class MagicCardsRouterTests: XCTestCase {

    func test_router_navigatesToMainScreen() {
        let navigationController = UINavigationController()
        let sut = getSut(navigationController: navigationController)

        sut.navigateToMain()
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is MainViewController)

    }

    func test_router_navigatesToCardsScreen() {
        let navigationController = UINavigationController()
        let sut = getSut(navigationController: navigationController)

        sut.navigateToCards()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is MagicCardsViewController)

    }

    func test_router_navigatesToCardDetailScreen() {
        let navigationController = UINavigationController()
        let sut = getSut(navigationController: navigationController)

        let card = Card(id: "84nf93owss", name: "My name", type: "My type", text: "My text", imageUrl: nil)
        sut.navigateToCardDetail(card)

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is MagicCardDetailViewController)

    }

    // MARK: - Util

    private func getSut(navigationController: UINavigationController) -> MagicCardsRouter {
        let sut = MagicCardsRouter(navigationController: navigationController)

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}
