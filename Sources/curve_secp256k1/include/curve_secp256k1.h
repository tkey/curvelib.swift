#include <stdbool.h>
#include <stdint.h>

#ifndef __curve_secp256k1_H__
#define __curve_secp256k1_H__ // Include guard

    #ifdef __cplusplus // Required for C++ compiler
    extern "C" {
    #endif
        //Forward Declarations
        struct PublicKey;
        struct SecretKey;
        struct Signature;
        struct PublicKeyCollection;

        // Version
        char* curve_secp256k1_get_version(int* error_code);

        // String
        void curve_secp256k1_string_free(char* ptr);

        // PrivateKey
        struct SecretKey* curve_secp256k1_private_key_generate();
        struct SecretKey* curve_secp256k1_private_key_parse(char* input,int* error_code);
        void curve_secp256k1_private_key_tweak_add_assign(struct SecretKey* key, struct SecretKey* tweak, int* error_code);
        void curve_secp256k1_private_key_tweak_mul_assign(struct SecretKey* key, struct SecretKey* tweak, int* error_code);
        void curve_secp256k1_private_key_inv_assign(struct SecretKey* key,int* error_code);
        struct SecretKey* curve_secp256k1_private_key_inv(struct SecretKey* key,int* error_code);
        struct PublicKey* curve_secp256k1_private_key_to_public_key(struct SecretKey* key,int* error_code);
        char* curve_secp256k1_private_key_serialize(struct SecretKey* key,int* error_code);
        void curve_secp256k1_private_key_free(struct SecretKey* key);

        // PublicKey
        struct PublicKey* curve_secp256k1_public_key_parse(char* input,int* error_code);
        char* curve_secp256k1_public_key_serialize(struct PublicKey* key, bool compress, int* error_code);
        void curve_secp256k1_public_key_tweak_add_assign(struct PublicKey* key,struct SecretKey* tweak,int* error_code: *mut c_int);
        void curve_secp256k1_public_key_tweak_mul_assign(struct PublicKey* key,struct PrivateKey* tweak,int* error_code);
        struct PublicKey* curve_secp256k1_public_key_combine(struct* PublicKeyCollection collection,int* error_code);
        void curve_secp256k1_public_key_free(struct PublicKey* key);

        // PublicKeyCollection
        struct PublicKeyCollection* curve_secp256k1_public_key_collection_new();
        void curve_secp256k1_public_key_collection_add(struct PublicKeyCollection* collection,struct PublicKey* key,int* error_code: *mut c_int);
        void curve_secp256k1_public_key_collection_free(struct PublicKeyCollection* collection);

        // Signature
        struct Signature* curve_secp256k1_ecdsa_signature_parse(char* input,int* error_code);
        char* curve_secp256k1_ecdsa_signature_serialize(struct Signature* sig,int* error_code);
        void curve_secp256k1_signature_free(struct Signature* signature);

        // ECDH
        char* curve_secp256k1_ecdh_sha256(struct SecretKey* secret,struct PublicKey* public_key,int* error_code: *mut c_int);
        pub unsafe extern "C" fn curve_secp256k1_ecdh_sha512(
            secret: *mut SecretKey,
            public: *mut PublicKey,
            error_code: *mut c_int,
        ) -> *mut c_char

        // ECDSA
        struct Signature* curve_secp256k1_ecdsa_sign_recoverable(struct PrivateKey* key,char* hash,int* error_code);
        struct PublicKey* curve_secp256k1_ecdsa_recover(struct Signature* signature,char* hash,int* error_code);
    #ifdef __cplusplus
    } // extern "C"
    #endif
#endif // __curve_secp256k1_H__
