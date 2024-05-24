
import Foundation

struct Card: Equatable, Decodable {

    let id: String
    let name: String
    let type: String
    let text: String
    let imageUrl: String?
}
