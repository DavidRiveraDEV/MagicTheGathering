
import Foundation

/// Convenience protocol to facilitate testing with URLSession

public protocol URLSession {

    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension Foundation.URLSession: URLSession {}
