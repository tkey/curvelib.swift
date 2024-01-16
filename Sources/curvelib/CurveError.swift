import Foundation

struct CurveError: Error, LocalizedError {
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
    
    public var errorDescription: String? {
        switch type {
            
        case .null:
            return "One or more of the parameters was null"
        case .convert:
            return "Invalid data was supplied"
        case .parse:
            return "Invalid data was supplied"
        case .tweakError:
            return "Cannot perform tweak operation"
        case .serialize:
            return "Serialization failed"
        case .keySizeError:
            return "Incorrect key size"
        case .signatureError:
            return "Incorrect data supplied for signing or recovery"
        case .unknownStatusCode:
            return "Library reported an unknown status code, please open an issue on github"
        }
    }
}
