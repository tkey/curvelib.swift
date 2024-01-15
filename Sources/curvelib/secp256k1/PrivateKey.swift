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

public extension Secp256k1 {
    
    class PrivateKey {
        public var rawData : Data;
        
        public init(input: Data? = nil ) throws {
            guard let inputData = input else {
                var errorCode: Int32 = -1
                
                let result = withUnsafeMutablePointer(to: &errorCode, { error in
                    w3a_secp256k1_private_key_generate(error)
                    
                })
                
                guard errorCode == 0 else {
                    throw RuntimeError("Error in getRaw representation")
                }
                let string = String(cString: result!)
                w3a_curvelib_string_free(result)
                
                rawData = try Data(hexString: string)
                return
            }
            rawData = inputData
        }
        
        public func getPublicKey() throws -> PublicKey {
            let pkey = try PublicKey.fromPrivateKey(privateKey: self.rawData)
            return pkey
        }
        
        public func getHexString() -> String {
            return rawData.hexString
        }
    }
}
