
import Foundation

protocol ScreenBuilder {

    func buildMainViewController(router: CardsRouter, willAppear: (() -> Void)?) -> MainViewController
    func buildMagicCardsViewController(router: CardsRouter) -> MagicCardsViewController
    func buildMagicCardDetailViewController(card: Card) -> MagicCardDetailViewController
}
