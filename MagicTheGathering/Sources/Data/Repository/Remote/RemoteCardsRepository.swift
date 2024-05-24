
import Foundation

final class RemoteCardsRepository: CardsRepository {

    private let api: CardsAPI
    private let session: URLSession

    init(api: CardsAPI, session: URLSession) {
        self.api = api
        self.session = session
    }

    func fetchCards() async throws -> [Card] {
        guard let url = URL(string: api.cards) else { throw CardsError.unknown }

        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CardsError.unknown
            }

            do {
                let cardsResponse = try JSONDecoder().decode(CardsResponse.self, from: data)
                return cardsResponse.cards
            } catch {
                throw CardsError.unknown
            }
        } catch let error as NSError {
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                throw CardsError.connection
            } else {
                throw CardsError.unknown
            }
        }
    }
}
