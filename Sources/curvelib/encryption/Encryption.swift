import Foundation

#if canImport(curvelib)
    import curvelib
#endif
import curveSecp256k1

public final class Encryption {
    public static func encrypt(pk: PublicKey, plainText: String) throws -> EncryptedMessage {
        var errorCode: Int32 = -1
        let stringPtr = UnsafeMutablePointer<Int8>(mutating: (plainText as NSString).utf8String)
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_aes_cbc_hmac_encrypt(pk.pointer, stringPtr, error)
        })
        
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
        
        return EncryptedMessage(ptr: result!)
    }
    
    public static func decrypt(sk: SecretKey, encrypted: EncryptedMessage) throws -> String {
        var errorCode: Int32 = -1
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_aes_cbc_hmac_decrypt(sk.pointer, encrypted.pointer, error)
        })
        
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
        
        let value = String(cString: result!)
        curve_secp256k1_string_free(result)
        return value
    }
}
