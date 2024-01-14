//
//  encryption.swift
//
//
//  Created by CW Lee on 12/01/2024.
//
#if canImport(tkeylibcurve)
    import tkeylibcurve
#endif
import Foundation


// return EncryptedMesssage Format
func encrypt( publicKey: String, data: Data , opts: ECIES? = nil ) throws  -> ECIES {
    var errorCode: Int32 = -1

    let messageStr = String(data: data, encoding: .utf8)
    
    let publicKeyPointer = UnsafeMutablePointer<Int8>(mutating: (publicKey as NSString).utf8String)
    let messagePointer = UnsafeMutablePointer<Int8>(mutating: (messageStr! as NSString).utf8String)
    
    let result = withUnsafeMutablePointer(to: &errorCode, { error in
        secp256k1_encrypt(publicKeyPointer, messagePointer, error)
    })
    guard errorCode == 0 else {
        throw RuntimeError("Error in Secp256k1 encryption")
    }
    
    let string = String(cString: result!)
    string_free(result)
    // expect decodabe result
    let jsonResult = try JSONDecoder().decode(ECIES.self, from: string.data(using: .utf8)!)
    
    return jsonResult
}


//
func decrypt( privateKey: String, data: ECIES ) throws -> Data {
    var errorCode: Int32 = -1
    let data = try JSONEncoder().encode(data);
    let messageStr = String(data: data, encoding: .utf8)
    
    let privateKeyPointer = UnsafeMutablePointer<Int8>(mutating: (privateKey as NSString).utf8String)
    let messagePointer = UnsafeMutablePointer<Int8>(mutating: (messageStr! as NSString).utf8String)
    
    let result = withUnsafeMutablePointer(to: &errorCode, { error in
        secp256k1_decrypt(privateKeyPointer, messagePointer, error)
    })
    guard errorCode == 0 else {
        throw RuntimeError("Error in Secp256k1 decryption")
    }
    
    let string = String(cString: result!)
    string_free(result)
    guard let resultData = string.data(using: .utf8) else {
        throw RuntimeError("Error in Secp256k1 encryption")
    }
    return resultData
}

