
import Foundation
import XCTest
import UIKit
@testable import MagicTheGathering

final class MagicCardsRouterTests: XCTestCase {

    func test_router_navigatesToMainScreen_onInitialization() throws {
        let sut = getSut()
        
        XCTAssertEqual(sut.rootViewController.viewControllers.count, 1)
        let navigationController = try XCTUnwrap(sut.rootViewController.viewControllers.first as? UINavigationController)
        XCTAssertTrue(navigationController.viewControllers.first is MainViewController)
    }

    func test_router_navigatesToCardsScreen_fromMainScreen() throws {
        let sut = getSut()

        sut.navigateToCards()

        let expectation = expectation(description: "presenting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.rootViewController.viewControllers.count, 1)
        let navigationController = try XCTUnwrap(sut.rootViewController.viewControllers.first as? UINavigationController)
        XCTAssertTrue(navigationController.viewControllers[0] is MainViewController)
        XCTAssertTrue(navigationController.viewControllers[1] is MagicCardsViewController)
    }

    func test_router_navigatesToCardDetailScreen_fromCardsScreen() throws {
        let sut = getSut()

        sut.navigateToCards()
        let card = Card(id: "84nf93owss", name: "My name", type: "My type", text: "My text", imageUrl: nil)
        sut.navigateToCardDetail(card)

        let expectation = expectation(description: "presenting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(sut.rootViewController.viewControllers.count, 2)
        let navigationController = try XCTUnwrap(sut.rootViewController.viewControllers.first as? UINavigationController)
        XCTAssertTrue(navigationController.viewControllers[0] is MainViewController)
        XCTAssertTrue(navigationController.viewControllers[1] is MagicCardsViewController)
        if sut.rootViewController.isCollapsed {
            XCTAssertTrue(navigationController.viewControllers[2] is MagicCardDetailViewController)
            XCTAssertTrue(sut.rootViewController.viewControllers.last is UINavigationController)
        } else {
            XCTAssertTrue(navigationController.viewControllers.last is MagicCardsViewController)
            XCTAssertTrue(sut.rootViewController.viewControllers.last is MagicCardDetailViewController)
        }
    }

    // MARK: - Util

    private func getSut() -> MagicCardsRouter {
        let sut = MagicCardsRouter()

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}
