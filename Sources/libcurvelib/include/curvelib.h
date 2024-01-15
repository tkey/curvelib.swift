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
        char* w3a_curvelib_get_version(int* error_code);
        void w3a_curvelib_string_free(char *ptr);
        void w3a_secp256k1_public_key_free(struct PublicKey* ptr);

        char* w3a_secp256k1_private_key_generate ( int* error_code);

        struct PublicKey* w3a_secp256k1_public_key_from_private_key ( char* private_key, int* error_code);
        struct PublicKey* w3a_secp256k1_public_key ( char* public_key, int* error_code);

        char* w3a_secp256k1_public_key_serialize(struct PublicKey* public_key, bool compress, int* error_code);
        
        struct PublicKey* w3a_secp256k1_public_key_combine ( char* public_keys, int* error_code);

        char* w3a_secp256k1_ecdsa_recoverable_sign ( char* private_key, char* message, int* error_code);
        
        char* w3a_secp256k1_aes_sha512_encrypt ( char* public_key, char* message, int* error_code);
        char* w3a_secp256k1_aes_sha512_decrypt ( char* private_key, char* message, int* error_code);
    #ifdef __cplusplus
    } // extern "C"
    #endif
#endif // __CURVELIB_H__
