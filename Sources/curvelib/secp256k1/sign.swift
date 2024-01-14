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

func sign (privateKey: String, hash: Data) throws -> String {
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
    
    let string = String(cString: result!)
    string_free(result)
    return string
}
