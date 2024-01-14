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

extension Data {
    init(hexString: String) throws {
        var hex = hexString
        // Remove any spaces or unwanted characters
        hex = hex.replacingOccurrences(of: " ", with: "")
        
        // Ensure the hex string has an even number of characters
        guard hex.count % 2 == 0 else {
            throw RuntimeError("Invalid hex format")
//            return nil
        }

        // Create an array of UInt8 values
        var bytes: [UInt8] = []
        var index = hex.startIndex
        while index < hex.endIndex {
            guard let byte = UInt8(hex[index...]) else {
//                return nil
                throw RuntimeError("Invalid hex format")
            }
            bytes.append(byte)
            index = hex.index(index, offsetBy: 2)
        }

        self.init(bytes)
    }
    
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}


class PrivateKey {
    public var rawData : Data;
    init(input: Data? = nil ) throws {
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
