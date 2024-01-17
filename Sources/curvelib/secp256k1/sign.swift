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
    
    static public func recoverableSign (privateKey: PrivateKey, hash: Data) throws -> RecoverableSignature {
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
        
        return try RecoverableSignature.init(pointer: result)
        
    }
    
    static public func recoverPublicKey( rSignature : RecoverableSignature, message: Data ) throws -> PublicKey {
        
        var errorCode: Int32 = -1
        
        let messagePointer = UnsafeMutablePointer<Int8>(mutating: (message.hexString as NSString).utf8String)
        
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            w3a_secp256k1_ecdsa_recover_public_key(rSignature.pointer, messagePointer, error)
        })
        guard errorCode == 0 else {
            throw RuntimeError("Error in Secp256k1 decryption")
        }
        
        return try PublicKey(inputPointer: result)
        
    }
    
    static public func ecdh (privateKey: PrivateKey, publicKey: PublicKey) throws -> Data {
        let privateKey = privateKey.getHexString()
        let publicKey = try publicKey.getRaw().hexString
        
        var errorCode: Int32 = -1
        
        let privateKeyPointer = UnsafeMutablePointer<Int8>(mutating: (privateKey as NSString).utf8String)
        let publicKeyPointer = UnsafeMutablePointer<Int8>(mutating: (publicKey as NSString).utf8String)
        
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            w3a_secp256k1_ecdh(privateKeyPointer, publicKeyPointer, error)
        })
        guard errorCode == 0 else {
            throw RuntimeError("Error in Secp256k1 decryption")
        }
        
        let string = String(cString: result!)
        w3a_curvelib_string_free(result)
        return try Data(hexString: string)
    }
}
