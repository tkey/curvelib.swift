import XCTest
import curvelib_swift

final class curvelibTests: XCTestCase {
    func testSecretKey() throws {
        let key = SecretKey()
        let serialized = try key.serialize()
        XCTAssertEqual(serialized.count, 64)
        let modifiable = try SecretKey(hex: serialized)
        let tweak = SecretKey()
        try modifiable.add_assign(key: tweak)
        try modifiable.mul_assign(key: tweak)
        try modifiable.inv_assign()
        let sk = try modifiable.inv()
        _ = try sk.to_public()
    }
    
    func testPublicKeyCollection() throws {
        let collection = PublicKeyCollection();
        try collection.insert(key: SecretKey().to_public())
        try collection.insert(key: SecretKey().to_public())
        try collection.insert(key: SecretKey().to_public())
        try collection.insert(key: SecretKey().to_public())
        try collection.insert(key: SecretKey().to_public())
        let _ = try PublicKey.combine(collection: collection)
    }
    
    func testPublicKey() throws {
        let pk = try SecretKey().to_public()
        try pk.add_assign(key: SecretKey())
        try pk.mul_assign(key: SecretKey())
        var serialized = try pk.serialize(compressed: false);
        XCTAssertEqual(serialized.count, 130)
        serialized = try pk.serialize(compressed: true);
        XCTAssertEqual(serialized.count, 66)
    }
    
    func testECDH() throws {
        let _ = try ECDH.SHA256(sk: SecretKey(), pk: SecretKey().to_public())
        let _ = try ECDH.SHA512(sk: SecretKey(), pk: SecretKey().to_public())
    }
    
    func testECDSA() throws {
        let sk = SecretKey()
        let pk = try sk.to_public()
        let messageHash = "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
        let signature = try ECDSA.sign_recoverable(key: sk, hash: messageHash)
        let rec = try ECDSA.recover(signature: signature, hash: messageHash)
        XCTAssertEqual(try pk.serialize(compressed: false), try rec.serialize(compressed: false))
    }
}
