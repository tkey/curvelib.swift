import Foundation

#if canImport(lib)
    import lib
#endif

public final class ECDH {
    public static func SHA256(sk: SecretKey, pk: PublicKey) throws -> String {
        var errorCode: Int32 = -1
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_ecdh_sha256(sk.pointer, pk.pointer, error)
        })
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
        let value = String(cString: result!)
        curve_secp256k1_string_free(result)
        return value
    }

    public static func SHA512(sk: SecretKey, pk: PublicKey) throws -> String {
        var errorCode: Int32 = -1
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_ecdh_sha512(sk.pointer, pk.pointer, error)
        })
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
        let value = String(cString: result!)
        curve_secp256k1_string_free(result)
        return value
    }
}
