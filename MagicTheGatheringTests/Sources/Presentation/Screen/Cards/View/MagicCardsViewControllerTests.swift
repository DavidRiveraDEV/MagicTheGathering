
import Foundation
import XCTest
@testable import MagicTheGathering

final class MagicCardsViewControllerTests: XCTestCase {

    static var alertExpectation: XCTestExpectation!

    func test_viewController_initialState() {

        let viewModel = MagicCardsViewModel(useCase: CardsUseCaseDummy())
        let sut = getSut(viewModel: viewModel, router: CardsRouterDummy())

        _ = sut.view

        XCTAssertTrue(sut.activityIndicator.isHidden)
        XCTAssertEqual(sut.tableView.numberOfSections, 1)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }

    func test_viewController_showsLoading_onLoadingState() {

        let viewModel = MagicCardsViewModel(useCase: CardsUseCaseDummy())
        let sut = getSut(viewModel: viewModel, router: CardsRouterDummy())

        _ = sut.view
        sut.set(state: .loading)

        XCTAssertTrue(sut.activityIndicator.isAnimating)
        XCTAssertFalse(sut.activityIndicator.isHidden)
    }

    func test_viewController_hidesLoading_onErrorState() {

        let viewModel = MagicCardsViewModel(useCase: CardsUseCaseDummy())
        let sut = getSut(viewModel: viewModel, router: CardsRouterDummy())

        _ = sut.view
        sut.set(state: .loading)
        sut.set(state: .error(.init(title: "", message: "")))

        XCTAssertFalse(sut.activityIndicator.isAnimating)
        XCTAssertTrue(sut.activityIndicator.isHidden)
    }

    func test_viewController_showsAlert_onErrorState() {
        Self.alertExpectation = XCTestExpectation(description: "alertExpectation")

        let viewModel = MagicCardsViewModel(useCase: CardsUseCaseDummy())
        let sut = getSut(viewModel: viewModel, router: CardsRouterDummy())

        let originalFunc = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.present(_:animated:completion:)))!
        let swizzledFunc = class_getInstanceMethod(MagicCardsViewControllerTests.self, #selector(self.presentAlert(_:animated:completion:)))!
        method_exchangeImplementations(originalFunc, swizzledFunc)

        _ = sut.view
        sut.set(state: .error(.init(title: "Title", message: "Message")))

        wait(for: [Self.alertExpectation], timeout: 1)

        method_exchangeImplementations(swizzledFunc, originalFunc)
    }

    @objc private func presentAlert(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) throws {
        let alertController = try XCTUnwrap(viewControllerToPresent as? UIAlertController)
        XCTAssertEqual(alertController.title, "Title")
        XCTAssertEqual(alertController.message, "Message")
        Self.alertExpectation.fulfill()
    }

    func test_viewController_hidesLoading_onShowingCardsState() {

        let viewModel = MagicCardsViewModel(useCase: CardsUseCaseDummy())
        let sut = getSut(viewModel: viewModel, router: CardsRouterDummy())

        _ = sut.view
        sut.set(state: .loading)
        sut.set(state: .showingCards([]))

        XCTAssertFalse(sut.activityIndicator.isAnimating)
        XCTAssertTrue(sut.activityIndicator.isHidden)
    }

    func test_viewController_showsCards_onShowingCardsState() {

        let viewModel = MagicCardsViewModel(useCase: CardsUseCaseDummy())
        let sut = getSut(viewModel: viewModel, router: CardsRouterDummy())

        _ = sut.view
        sut.set(state: .loading)
        sut.set(state: .showingCards([
            Card(id: "b7c19924", name: "Card 1", type: "Type 1", text: "Text 1", imageUrl: nil),
            Card(id: "586e940bd42", name: "Card 2", type: "Type 2", text: "Text 3", imageUrl: "https://image.url/2"),
            Card(id: "56fcaa73", name: "Card 3", type: "Type 3", text: "Text 3", imageUrl: "https://image.url/3")
        ]))

        XCTAssertEqual(sut.tableView.numberOfSections, 1)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 3)
    }

    // MARK: Util

    private func getSut(viewModel: MagicCardsViewModel, router: CardsRouter) -> MagicCardsViewController {
        let sut = MagicCardsViewController(viewModel: viewModel, router: router)

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}
