import XCTest
#if !COCOAPODS

    import common
    @testable import curveSecp256k1
#endif

final class curvelibErrorTests: XCTestCase {
    func testCurveError() {
        var error = CurveError(code: 0)
        XCTAssertEqual(error.type,.unknownStatusCode)
        
        error = CurveError(code: 1)
        XCTAssertEqual(error.type, .null)
        
        error = CurveError(code: 2)
        XCTAssertEqual(error.type, .convert)
        
        error = CurveError(code: 3)
        XCTAssertEqual(error.type, .parse)
        
        error = CurveError(code: 4)
        XCTAssertEqual(error.type, .tweak)
        
        error = CurveError(code: 5)
        XCTAssertEqual(error.type, .serialize)
        
        error = CurveError(code: 6)
        XCTAssertEqual(error.type, .keySize)
        
        error = CurveError(code: 7)
        XCTAssertEqual(error.type, .signature)
        
        error = CurveError(code: 8)
        XCTAssertEqual(error.type, .invalidMac)
        
        error = CurveError(code: 9)
        XCTAssertEqual(error.type, .encryption)
        
        error = CurveError(code: 10)
        XCTAssertEqual(error.type, .decryption)
    }
}


