import Foundation

#if canImport(lib)
    import lib
#endif

public final class PublicKey {
    private(set) var pointer: OpaquePointer?

    internal init(ptr: OpaquePointer) {
        pointer = ptr
    }

    public static func combine(collection: PublicKeyCollection) throws -> PublicKey {
        var errorCode: Int32 = -1
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_public_key_combine(collection.pointer, error)
        })
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
        return PublicKey(ptr: result!)
    }

    public init(hex: String) throws {
        var errorCode: Int32 = -1
        let hexPtr = UnsafeMutablePointer<Int8>(mutating: (hex as NSString).utf8String)
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_public_key_parse(hexPtr, error)
        })
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
        pointer = result
    }

    public func add_assign(key: SecretKey) throws {
        var errorCode: Int32 = -1
        withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_public_key_tweak_add_assign(pointer, key.pointer, error)
        })
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
    }

    public func mul_assign(key: SecretKey) throws {
        var errorCode: Int32 = -1
        withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_public_key_tweak_mul_assign(pointer, key.pointer, error)
        })
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
    }

    public func serialize(compressed: Bool) throws -> String {
        var errorCode: Int32 = -1
        let result = withUnsafeMutablePointer(to: &errorCode, { error in
            curve_secp256k1_public_key_serialize(pointer, compressed, error)
        })
        guard errorCode == 0 else {
            throw CurveError(code: errorCode)
        }
        let value = String(cString: result!)
        curve_secp256k1_string_free(result)
        return value
    }

    deinit {
        curve_secp256k1_private_key_free(pointer)
    }
}