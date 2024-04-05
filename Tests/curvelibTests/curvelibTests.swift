import XCTest

#if !COCOAPODS
    @testable import curveSecp256k1
    @testable import encryption_aes_cbc_sha512
    @testable import sha3
#endif

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
        _ = try signature.serialize_der()
    }
    
    func testEncryption() throws {
        let sk = SecretKey()
        let pk = try sk.toPublic()
        let plainText = "this is testing data";
        let encrypted = try Encryption.encrypt(pk: pk, data: plainText.data(using: .utf8)! )
        let cipherText = try encrypted.chipherText()
        let ephemeralPk = try encrypted.ephemeralPublicKey()
        let iv = try encrypted.iv()
        let mac = try encrypted.mac()
        let components = try EncryptedMessage(cipherText: cipherText, ephemeralPublicKey: ephemeralPk, iv: iv, mac: mac)
        let decrypted = try Encryption.decrypt(sk: sk, encrypted: components)
        XCTAssertEqual(plainText.data(using: .utf8)!, decrypted)
    }
    
    func testEncryptionSkipMacCheck() throws {
        let sk = SecretKey()
        let pk = try sk.toPublic()
        let plainText = "this is testing data";
        let encrypted = try Encryption.encrypt(pk: pk, data: plainText.data(using: .utf8)!)
        let cipherText = try encrypted.chipherText()
        let ephemeralPk = try encrypted.ephemeralPublicKey()
        let iv = try encrypted.iv()
        let components = try EncryptedMessage(cipherText: cipherText, ephemeralPublicKey: ephemeralPk, iv: iv, mac: "")
        let decrypted = try Encryption.decrypt(sk: sk, encrypted: components, skipMacCheck: true)
        
        XCTAssertThrowsError(try Encryption.decrypt(sk: sk, encrypted: components, skipMacCheck: false))
        XCTAssertEqual(plainText.data(using: .utf8)!, decrypted)
    }
    
    func testEncryptionNonUTF8() throws {
        let sk = try SecretKey(hex: "8db351704caeb01a7c7ae4860f40fb46b932e4a5ecb6283cc8481126127bf67f")
        
        let ephemeralPk = try PublicKey(hex: "0422472e27b6231cd657388711591ef86c1037207a72e063acf91c34f39a839ef259875d02b2f9348d890207f7f6e8e68e6f6983231aca2439d4faede4d1ea2920")

        let components = try EncryptedMessage(cipherText: "c3a8d319f0f2b1cd5a453dc24ae76746b1039363fba4ddb065ba67ab4fd0583e8e01f327875a968b0274d05da1d3bfe2", ephemeralPublicKey: ephemeralPk, iv: "ee03ea6170dd9a43b1a7d6f52af0d7af", mac: "ef15d00f9a5ec3c8a8a2cb0724a624fc3b21db9e25ccc3318f83fbe06d8dd18d")
        let decrypted = try Encryption.decrypt(sk: sk, encrypted: components, skipMacCheck: false)
        
        print(decrypted)
    }
    
    func testkeccak256() throws {
        let data = "hello world!"
        let hash = try keccak256(data: data.data(using: .utf8)!)
        print(hash.hexString)
        XCTAssert(hash.hexString == "57caa176af1ac0433c5df30e8dabcd2ec1af1e92a26eced5f719b88458777cd6")
    }
}
