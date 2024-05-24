
import Foundation
@testable import MagicTheGathering

class URLSessionStub: MagicTheGathering.URLSession {

    var error: Error?
    var result: (Data, URLResponse)?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let result else {
            throw error ?? NSError()
        }
        return result
    }
}
