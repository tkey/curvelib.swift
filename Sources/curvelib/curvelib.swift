// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public extension Data {
    init(hexString: String) throws {
        let hex = hexString
        guard hex.count.isMultiple(of: 2) else {
            throw RuntimeError("Invalid hex format")
        }
        
        let chars = hex.map { $0 }
        let bytes = stride(from: 0, to: chars.count, by: 2)
            .map { String(chars[$0]) + String(chars[$0 + 1]) }
            .compactMap { UInt8($0, radix: 16) }
        
        guard hex.count / bytes.count == 2 else {
            //            return nil
            throw RuntimeError("Invalid hex format")
        }
        self.init(bytes)
    }
    
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
