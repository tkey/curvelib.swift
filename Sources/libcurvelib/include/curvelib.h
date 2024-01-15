#include <stdbool.h>
#include <stdint.h>

#ifndef __CURVELIB_H__
#define __CURVELIB_H__ // Include guard

    #ifdef __cplusplus // Required for C++ compiler
    extern "C" {
    #endif

        //Forward Declarations
        struct PublicKey;
        //Methods
        char* get_version(int* error_code);
        void string_free(char *ptr);
        void secp256k1_public_key_free(struct PublicKey* ptr);

        char* secp256k1_private_key_generate ( int* error_code);

        struct PublicKey* secp256k1_public_key_from_private_key ( char* private_key, int* error_code);
        struct PublicKey* secp256k1_public_key ( char* public_key, int* error_code);

        char* secp256k1_public_key_raw(struct PublicKey* public_key, int* error_code);
        char* secp256k1_public_key_sec1_compress(struct PublicKey* public_key, int* error_code);
        char* secp256k1_public_key_sec1_full(struct PublicKey* public_key, int* error_code);
        
        struct PublicKey* secp256k1_public_key_combine ( char* public_keys, int* error_code);

        char* secp256k1_ecdsa_sign ( char* private_key, char* message, int* error_code);
        
        char* secp256k1_encrypt ( char* public_key, char* message, int* error_code);
        char* secp256k1_decrypt ( char* private_key, char* message, int* error_code);
    #ifdef __cplusplus
    } // extern "C"
    #endif
#endif // __CURVELIB_H__
