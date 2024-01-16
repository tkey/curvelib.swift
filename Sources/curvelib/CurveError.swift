import Foundation

struct CurveError: Error {
    enum ErrorType {
        case null
        case convert
        case parse
        case tweakError
        case serialize
        case keySizeError
        case signatureError
        case unknownStatusCode
    }

    let type: ErrorType

    init(code: Int32) {
        switch code {
        case 1: type = .null
        case 2: type = .convert
        case 3: type = .parse
        case 4: type = .tweakError
        case 5: type = .serialize
        case 6: type = .keySizeError
        case 7: type = .signatureError
        default: type = .unknownStatusCode
        }
    }
}
