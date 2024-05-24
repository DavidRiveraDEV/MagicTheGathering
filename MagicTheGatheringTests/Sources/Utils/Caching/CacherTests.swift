
import Foundation
import XCTest
@testable import MagicTheGathering

final class CacherTests: XCTestCase {

    func test_cacher_doesNotGetElement_whenNotSaved() async {
        let sut = Cacher<String, Int>()

        let savedValue = await sut.getValue(for: "MyKey")

        XCTAssertNil(savedValue)
    }

    func test_cacher_getsElement_whenSaved() async {
        let sut = Cacher<String, Int>()

        let key = "MyKey"
        let value = 10

        await sut.save(value, for: key)
        let savedValue = await sut.getValue(for: key)

        XCTAssertEqual(savedValue, value)
    }

    func test_cacher_removesElement_whenSaved() async {
        let sut = Cacher<String, Int>()

        let key = "MyKey"
        let value = 10

        await sut.save(value, for: key)
        await sut.removeValue(forKey: key)
        let savedValue = await sut.getValue(for: key)

        XCTAssertNil(savedValue)
    }
}
