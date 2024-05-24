
import Foundation
import XCTest
@testable import MagicTheGathering

final class MainViewControllerTests: XCTestCase {

    func test_viewController_navigatesToCardsViewController() {
        let router = CardsRouterSpy()
        let sut = getSut(router: router)

        _ = sut.view
        sut.startButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(router.navigateToCards_calledTimes, 1)
    }

    // MARK: - Util

    private func getSut(router: CardsRouter) -> MainViewController {
        let sut = MainViewController.instantiate(router: router)

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}
