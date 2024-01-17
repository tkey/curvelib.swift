import XCTest
@testable import curvelib_swift

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
        XCTAssertEqual(error.type, .tweakError)
        
        error = CurveError(code: 5)
        XCTAssertEqual(error.type, .serialize)
        
        error = CurveError(code: 6)
        XCTAssertEqual(error.type, .keySizeError)
        
        error = CurveError(code: 7)
        XCTAssertEqual(error.type, .signatureError)
    }
}


