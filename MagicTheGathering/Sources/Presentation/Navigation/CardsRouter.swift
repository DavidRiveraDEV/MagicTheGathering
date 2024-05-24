
import Foundation

protocol CardsRouter: AnyObject {

    func navigateToMain()
    func navigateToCards()
    func navigateToCardDetail(_ card: Card)
}
