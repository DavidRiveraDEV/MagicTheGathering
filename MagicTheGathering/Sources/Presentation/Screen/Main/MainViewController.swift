
import Foundation
import UIKit

final class MainViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!

    var router: CardsRouter?

    @IBAction private func startButtonDidTap() {
        router?.navigateToCards()
    }
}

extension MainViewController {

    static func instantiate(router: CardsRouter) -> MainViewController {
        let storyboard = UIStoryboard.main
        let identifier = String(describing: MainViewController.self)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? MainViewController
        viewController?.router = router
        return viewController ?? MainViewController()
    }
}
