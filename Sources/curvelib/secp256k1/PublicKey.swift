//
//  PublicKey.swift
//  
//
//  Created by CW Lee on 12/01/2024.
//
#if canImport(tkeylibcurve)
    import tkeylibcurve
#endif

import Foundation

public extension Secp256k1 {
    
    class PublicKey {
        
        private(set) var pointer: OpaquePointer?
        
        static public func fromPrivateKey ( privateKey : Data ) throws -> PublicKey {
            let privateKey = privateKey.hexString
            
            var errorCode: Int32 = -1
            let privateKeyPointer = UnsafeMutablePointer<Int8>(mutating: (privateKey as NSString).utf8String)
            
            
            let ptr = withUnsafeMutablePointer(to: &errorCode, { error in
                secp256k1_public_key_from_private_key(privateKeyPointer, error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in derive Public Key from Private Key")
            }
            
            return PublicKey(inputPointer: ptr)
        }
        
        static public func combine ( publicKeys : [PublicKey] ) throws -> PublicKey {
            let publickeysArray = try publicKeys.map { try $0.getRaw() }
            
            let serialized = try JSONSerialization.data(withJSONObject: publickeysArray)
            guard let serializeString = String(bytes: serialized, encoding: .utf8) else {
                throw RuntimeError("Invalid Public Keys")
            }
            
            var errorCode: Int32 = -1
            let serializeStringPointer = UnsafeMutablePointer<Int8>(mutating: (serializeString as NSString).utf8String)
            
            
            let ptr = withUnsafeMutablePointer(to: &errorCode, { error in
                secp256k1_public_key_combine(serializeStringPointer, error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in derive Public Key from Private Key")
            }
            
            return PublicKey(inputPointer: ptr)
        }
        
        public init( input: Data ) throws {
            let input = input.hexString;
            
            var errorCode: Int32 = -1
            let inputPointer = UnsafeMutablePointer<Int8>(mutating: (input as NSString).utf8String)
            
            
            let ptr = withUnsafeMutablePointer(to: &errorCode, { error in
                secp256k1_public_key(inputPointer, error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in initialize Public Key")
            }
            self.pointer = ptr
        }
        
        init ( inputPointer: OpaquePointer? ) {
            self.pointer = inputPointer
        }
        
        public func getRaw () throws -> String {
            var errorCode: Int32 = -1
            let result = withUnsafeMutablePointer(to: &errorCode, { error in
                secp256k1_public_key_raw(self.pointer, error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in getRaw representation")
            }
            let string = String(cString: result!)
            string_free(result)
            return string
        }
        
        public func getSec1Full () throws -> String {
            var errorCode: Int32 = -1
            let result = withUnsafeMutablePointer(to: &errorCode, { error in
                secp256k1_public_key_sec1_full(self.pointer, error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in getRaw representation")
            }
            let string = String(cString: result!)
            string_free(result)
            return string
        }
        
        public func getSec1Compress () throws -> String {
            var errorCode: Int32 = -1
            let result = withUnsafeMutablePointer(to: &errorCode, { error in
                secp256k1_public_key_sec1_compress(self.pointer, error)
            })
            guard errorCode == 0 else {
                throw RuntimeError("Error in getRaw representation")
            }
            let string = String(cString: result!)
            string_free(result)
            return string
        }
        
        deinit{
            secp256k1_public_key_free(self.pointer)
        }
    }
}
