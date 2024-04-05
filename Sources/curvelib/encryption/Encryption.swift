import Foundation

#if canImport(curvelib)
    import curvelib
#endif

#if canImport(curveSecp256k1)
    import curveSecp256k1
#endif

extension Data {
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
    
    init?(hexString: String) {
        // Ensure the string has an even number of characters
        guard hexString.count % 2 == 0 else { return nil }
        
        var data = Data(capacity: hexString.count / 2)
        
        // Convert each pair of characters to a byte and append to data
        var index = hexString.startIndex
        while index < hexString.endIndex {
            let nextIndex = hexString.index(index, offsetBy: 2)
            if let byte = UInt8(hexString[index..<nextIndex], radix: 16) {
                data.append(byte)
            } else {
                return nil // Invalid hexadecimal character
            }
            index = nextIndex
        }
        
        self = data
    }
}

public final class Encryption {
    public static func encrypt(pk: PublicKey, data: Data) throws -> EncryptedMessage {
        var errorCode: Int32 = -1
        let stringPtr = UnsafeMutablePointer<Int8>(mutating: (data.hexString as NSString).utf8String)
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_aes_cbc_hmac_encrypt(pk.pointer, stringPtr, error)
        })
        
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
        
        return EncryptedMessage(ptr: result!)
    }
    
    public static func decrypt(sk: SecretKey, encrypted: EncryptedMessage, skipMacCheck:Bool = false) throws -> Data {
        var errorCode: Int32 = -1
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_aes_cbc_hmac_decrypt(sk.pointer, encrypted.pointer, skipMacCheck, error)
        })
        
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
        
        let value = String(cString: result!)
        curve_secp256k1_string_free(result)
        
        guard let result =  Data(hexString: value) else {
            throw CurveError(code: 9)
        }
        return result
    }
}
