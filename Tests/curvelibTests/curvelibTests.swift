import XCTest
import curvelib_swift

final class curvelibTests: XCTestCase {
    func testSecretKey() throws {
        let key = SecretKey()
        let serialized = try key.serialize()
        XCTAssertEqual(serialized.count, 64)
    }
}
