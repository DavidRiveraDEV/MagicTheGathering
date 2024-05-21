
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

// IMPL

import Combine

final class MagicCardsViewController: UITableViewController {

    private let viewModel: MagicCardsViewModel
    private let router: CardsRouter
    private var cards: [Card] = []

    private var cancellables = Set<AnyCancellable>()

    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.isHidden = true
        return view
    }()

    init(viewModel: MagicCardsViewModel, router: CardsRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadCards()
    }

    private func bind() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.set(state: state)
            }.store(in: &cancellables)
    }

    func set(state: CardsViewState) {
        switch state {
        case .loading:
            showLoading(true)
            break
        case .error(let errorMessage):
            showLoading(false)
            presentError(errorMessage)
            break
        case .showingCards(let cards):
            showLoading(false)
            self.cards = cards
            tableView.reloadData()
            break
        }
    }

    private func showLoading(_ loading: Bool) {
        activityIndicator.isHidden = !loading
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    private func presentError(_ errorMessage: ErrorMessage) {
        let alert = UIAlertController(title: errorMessage.title, message: errorMessage.message, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
    }
}

// Datasource

extension MagicCardsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        let card = cards[indexPath.row]
        content.text = card.name
        content.secondaryText = "Type: \(card.type)"
        cell.contentConfiguration = content
        return cell
    }
}
