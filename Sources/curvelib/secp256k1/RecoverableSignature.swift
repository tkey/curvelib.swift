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
        public var signature : String
        public var recoverId : Int
        var pointer : OpaquePointer?
        
        public init(pointer: OpaquePointer?) throws {
            var errorCode: Int32 = -1
            let result = withUnsafeMutablePointer(to: &errorCode, { error in
                w3a_secp256k1_recoverable_signature_serialize_compact(pointer, error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in RecoverableSignature : invalid format")
            }
            self.signature = String(cString: result!)
            w3a_curvelib_string_free(result)
            
            errorCode = -1
            let rid = withUnsafeMutablePointer(to: &errorCode, { error in
                w3a_secp256k1_recoverable_signature_recover_id(pointer, error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in RecoverableSignature : invalid format")
            }
            self.recoverId = Int(rid)
            self.pointer = pointer
            
        }
         
        
        public init ( signature: Data, recoverId: Int ) throws {
            var errorCode: Int32 = -1
            
            let signaturePointer = UnsafeMutablePointer<Int8>(mutating: (signature.hexString as NSString).utf8String)
            
            let result = withUnsafeMutablePointer(to: &errorCode, { error in
                w3a_secp256k1_recoverable_signature(signaturePointer, Int32(recoverId), error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in RecoverableSignature : invalid format")
            }
            self.signature = signature.hexString
            self.recoverId = recoverId
            self.pointer = result
        }
        
        deinit {
            w3a_secp256k1_recoverable_signature_free(self.pointer)
        }
    }
    
}
