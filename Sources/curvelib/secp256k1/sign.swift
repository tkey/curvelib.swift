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
        var signature : String
        var recover_id : Int
    }
    
    public func Sign (privateKey: PrivateKey, hash: Data) throws -> RecoverableSignature {
        let privateKey = privateKey.getHexString()
        
        var errorCode: Int32 = -1
        
        let hashStr = String(data: hash, encoding: .utf8)
        
        let privateKeyPointer = UnsafeMutablePointer<Int8>(mutating: (privateKey as NSString).utf8String)
        let messagePointer = UnsafeMutablePointer<Int8>(mutating: (hashStr! as NSString).utf8String)
        
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            secp256k1_ecdsa_sign(privateKeyPointer, messagePointer, error)
        })
        guard errorCode == 0 else {
            throw RuntimeError("Error in Secp256k1 decryption")
        }
        
        let stringData = String(cString: result!).data(using: .utf8)!
        string_free(result)
        
        let jsonObj = try JSONDecoder().decode(RecoverableSignature.self, from: stringData)
        return jsonObj
    }
}
