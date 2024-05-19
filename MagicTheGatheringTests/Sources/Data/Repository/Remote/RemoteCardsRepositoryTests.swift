
import Foundation
import XCTest
@testable import MagicTheGathering

final class RemoteCardsRepositoryTests: XCTestCase {

    func test_repository_getsCards_withConnectionError() async {
        let session = URLSessionStub()
        session.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        let sut = getSut(api: MagicCardsAPI(), session: session)

        do {
            _ = try await sut.fetchCards()
            XCTFail("Expected connection error")
        } catch {
            XCTAssertEqual(error as? CardsError, .connection)
        }
    }

    func test_repository_getsCards_withUnknownError_withBadURL() async {
        let api = MagicCardsAPIStub(cards: "")
        let sut = getSut(api: api, session: URLSession.shared)

        do {
            _ = try await sut.fetchCards()
            XCTFail("Expected unknown error")
        } catch {
            XCTAssertEqual(error as? CardsError, .unknown)
        }
    }

    func test_repository_getsCards_withUnknownError_withBadResponse() async {
        let session = URLSessionStub()
        session.result = (Data(), HTTPURLResponse(url: URL(string: "http://web.com")!,
                                                  statusCode: 400,
                                                  httpVersion: nil,
                                                  headerFields: nil)!)
        let sut = getSut(api: MagicCardsAPI(), session: session)

        do {
            _ = try await sut.fetchCards()
            XCTFail("Expected unknown error")
        } catch {
            XCTAssertEqual(error as? CardsError, .unknown)
        }
    }

    func test_repository_getsCards_withUnknownError_withWrongData() async {
        let session = URLSessionStub()
        session.result = (Data(), HTTPURLResponse(url: URL(string: "http://web.com")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)!)
        let sut = getSut(api: MagicCardsAPI(), session: session)

        do {
            _ = try await sut.fetchCards()
            XCTFail("Expected unknown error")
        } catch {
            XCTAssertEqual(error as? CardsError, .unknown)
        }
    }

    func test_repository_getsCards_withSuccess() async throws {
        let jsonString = #"[{"id":"1","name":"Name 1","type":"Type 1","text":"Text 1","imageUrl":"Url 1"},{"id":"2","name":"Name 2","type":"Type 2","text":"Text 2","imageUrl":"Url 2"},{"id":"3","name":"Name 3","type":"Type 3","text":"Text 3","imageUrl":"Url 3"}]"#
        let data = jsonString.data(using: .utf8)!
        let session = URLSessionStub()
        session.result = (data, HTTPURLResponse(url: URL(string: "http://web.com")!,
                                                statusCode: 200,
                                                httpVersion: nil,
                                                headerFields: nil)!)
        let sut = getSut(api: MagicCardsAPI(), session: session)

        let cards = try await sut.fetchCards()

        let expectedCards = [
            Card(id: "1", name: "Name 1", type: "Type 1", text: "Text 1", imageUrl: "Url 1"),
            Card(id: "2", name: "Name 2", type: "Type 2", text: "Text 2", imageUrl: "Url 2"),
            Card(id: "3", name: "Name 3", type: "Type 3", text: "Text 3", imageUrl: "Url 3")
        ]

        XCTAssertEqual(expectedCards, cards)
    }

    // MARK: - Util

    private func getSut(api: CardsAPI, session: MagicTheGathering.URLSession) -> RemoteCardsRepository {
        let sut = RemoteCardsRepository(api: api, session: session)

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}
