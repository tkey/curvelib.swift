//
//  PrivateKey.swift
//  
//
//  Created by CW Lee on 14/01/2024.
//

#if canImport(tkeylibcurve)
    import tkeylibcurve
#endif
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


public class PrivateKey {
    public var rawData : Data;
    
    public init(input: Data? = nil ) throws {
        guard let inputData = input else {
            var errorCode: Int32 = -1

            let result = withUnsafeMutablePointer(to: &errorCode, { error in
                secp256k1_private_key_generate(error)
                
            })
            
            guard errorCode == 0 else {
                throw RuntimeError("Error in getRaw representation")
            }
            let string = String(cString: result!)
            string_free(result)
            
            rawData = try Data(hexString: string)
            return
        }
        rawData = inputData
    }
    
    public func getHexString() -> String {
        return rawData.hexString
    }
}
