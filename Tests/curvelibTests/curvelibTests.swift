import XCTest
import secp256k1_swift
import encryption_aes_cbc_sha512_swift

final class curvelibTests: XCTestCase {
    func testSecretKey() throws {
        let key = SecretKey()
        let serialized = try key.serialize()
        XCTAssertEqual(serialized.count, 64)
        let modifiable = try SecretKey(hex: serialized)
        let tweak = SecretKey()
        try modifiable.addAssign(key: tweak)
        try modifiable.mulAssign(key: tweak)
        try modifiable.invAssign()
        let sk = try modifiable.inv()
        _ = try sk.toPublic()
    }
    
    func testPublicKeyCollection() throws {
        let collection = PublicKeyCollection();
        try collection.insert(key: SecretKey().toPublic())
        try collection.insert(key: SecretKey().toPublic())
        try collection.insert(key: SecretKey().toPublic())
        try collection.insert(key: SecretKey().toPublic())
        try collection.insert(key: SecretKey().toPublic())
        let _ = try PublicKey.combine(collection: collection)
    }
    
    func testPublicKey() throws {
        let pk = try SecretKey().toPublic()
        try pk.addAssign(key: SecretKey())
        try pk.mulAssign(key: SecretKey())
        _ = try pk.mul(key: SecretKey())
        var serialized = try pk.serialize(compressed: false);
        XCTAssertEqual(serialized.count, 130)
        serialized = try pk.serialize(compressed: true);
        XCTAssertEqual(serialized.count, 66)
    }
    
    func testECDH() throws {
        let _ = try ECDH.ecdh(sk: SecretKey(), pk: SecretKey().toPublic())
        let _ = try ECDH.ecdhStandard(sk: SecretKey(), pk: SecretKey().toPublic())
    }
    
    func testECDSA() throws {
        let sk = SecretKey()
        let pk = try sk.toPublic()
        let messageHash = "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
        let signature = try ECDSA.signRecoverable(key: sk, hash: messageHash)
        let rec = try ECDSA.recover(signature: signature, hash: messageHash)
        XCTAssertEqual(try pk.serialize(compressed: false), try rec.serialize(compressed: false))
        _ = try Signature(hex: signature.serialize())
    }
    
    func testEncryption() throws {
        let sk = SecretKey()
        let pk = try sk.toPublic()
        let plainText = "this is testing data";
        let encrypted = try Encryption.encrypt(pk: pk, plainText: plainText)
        let cipherText = try encrypted.chipherText()
        let ephemeralPk = try encrypted.ephemeralPublicKey()
        let iv = try encrypted.iv()
        let mac = try encrypted.mac()
        let components = try EncryptedMessage(cipherText: cipherText, ephemeralPublicKey: ephemeralPk, iv: iv, mac: mac)
        let decrypted = try Encryption.decrypt(sk: sk, encrypted: components)
        XCTAssertEqual(plainText, decrypted)
    }
}
