
import Foundation
import UIKit
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
}

// MARK: - State

extension MagicCardsViewController {

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

// MARK: - Datasource

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
