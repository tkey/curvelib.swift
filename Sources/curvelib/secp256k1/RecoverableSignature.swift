//
//  RecoverableSignature.swift
//  
//
//  Created by CW Lee on 16/01/2024.
//

import Foundation

#if canImport(tkeylibcurve)
    import tkeylibcurve
#endif
public extension Secp256k1 {
    class RecoverableSignature {
        public var signature : Data
        public var recoverId : UInt8
        var pointer : OpaquePointer?
        
        public init(pointer: OpaquePointer?) throws {
            var errorCode: Int32 = -1
            let result = withUnsafeMutablePointer(to: &errorCode, { error in
                w3a_secp256k1_recoverable_signature_serialize_compact(pointer, error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in RecoverableSignature : invalid format")
            }
            self.signature = try Data(hexString:String(cString: result!))
            w3a_curvelib_string_free(result)
            
            errorCode = -1
            let rid = withUnsafeMutablePointer(to: &errorCode, { error in
                w3a_secp256k1_recoverable_signature_recover_id(pointer, error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in RecoverableSignature : invalid format")
            }
            self.recoverId = UInt8(rid)
            self.pointer = pointer
            
        }
         
        
        public init ( signature: Data, recoverId: UInt8 ) throws {
            var errorCode: Int32 = -1
            let signaturePointer = UnsafeMutablePointer<Int8>(mutating: (signature.hexString as NSString).utf8String)
            
            let result = withUnsafeMutablePointer(to: &errorCode, { error in
                w3a_secp256k1_recoverable_signature(signaturePointer, Int32(recoverId), error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in RecoverableSignature : invalid format")
            }
            self.signature = signature
            self.recoverId = recoverId
            self.pointer = result
        }
        
        public convenience init ( r: Data, s: Data, v: UInt8)  throws {
            if r.count != 32 || s.count != 32 {
                throw RuntimeError("Invalid r/s format")
            }
            
            try self.init(signature: r + s, recoverId: v)
        }
        
        deinit {
            w3a_secp256k1_recoverable_signature_free(self.pointer)
        }
    }
    
}
