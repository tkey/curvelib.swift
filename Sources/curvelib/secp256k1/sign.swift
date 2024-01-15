//
//  Sign.swift
//
//
//  Created by CW Lee on 12/01/2024.
//

#if canImport(tkeylibcurve)
    import tkeylibcurve
#endif
import Foundation

public class Secp256k1 {
    public struct RecoverableSignature : Codable {
        public var signature : String
        public var recover_id : Int
    }
    
    static public func Sign (privateKey: PrivateKey, hash: Data) throws -> RecoverableSignature {
        let privateKey = privateKey.getHexString()
        
        var errorCode: Int32 = -1
        
        let hashStr = hash.hexString
        
        let privateKeyPointer = UnsafeMutablePointer<Int8>(mutating: (privateKey as NSString).utf8String)
        let messagePointer = UnsafeMutablePointer<Int8>(mutating: (hashStr as NSString).utf8String)
        
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            w3a_secp256k1_ecdsa_recoverable_sign(privateKeyPointer, messagePointer, error)
        })
        guard errorCode == 0 else {
            throw RuntimeError("Error in Secp256k1 decryption")
        }
        
        let stringData = String(cString: result!).data(using: .utf8)!
        w3a_curvelib_string_free(result)
        
        let jsonObj = try JSONDecoder().decode(RecoverableSignature.self, from: stringData)
        return jsonObj
    }
}
