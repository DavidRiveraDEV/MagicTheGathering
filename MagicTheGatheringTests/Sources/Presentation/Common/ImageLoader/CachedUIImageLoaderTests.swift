
import Foundation
import XCTest
import UIKit
@testable import MagicTheGathering

final class CachedUIImageLoaderTests: XCTestCase {

    func test_loader_loadsImageFromRepository_whenNotSaved() async throws {
        let imageLoader = UIImageLoaderSpy()
        let sut = getSut(imageLoader: imageLoader)

        let url = URL(string: "http://image.url")!
        _ = await sut.load(from: url)

        XCTAssertEqual(imageLoader.loadFrom_urls, [url])
    }

    func test_repository_fetchesCardsFromCache_whenSaved() async throws {
        let expectedImage = UIImage(systemName: "photo")
        let imageLoader = UIImageLoaderMock()
        imageLoader.loadFrom_return = expectedImage
        let sut = getSut(imageLoader: imageLoader)

        let url = URL(string: "http://image.url")!
        _ = await sut.load(from: url)
        imageLoader.loadFrom_return = nil
        let retrievedImage = await sut.load(from: url)

        XCTAssertEqual(imageLoader.loadFrom_urls, [url])
        XCTAssertEqual(expectedImage, retrievedImage)
    }

    // MARK: - Util

    func getSut(imageLoader: UIImageLoader) -> CachedUIImageLoader {
        let cacher = Cacher<String, UIImage>()
        let sut = CachedUIImageLoader(imageLoader: imageLoader, cacher: cacher)

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }
}
