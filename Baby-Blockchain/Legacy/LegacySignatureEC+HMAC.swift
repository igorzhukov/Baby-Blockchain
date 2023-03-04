//
//  LegacySignatureEC+HMAC.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 04.03.2023.
//

import Foundation
import CommonCrypto

// MARK: <=iOS15
/// https://code.tutsplus.com/tutorials/creating-digital-signatures-with-swift--cms-29287
///
///
/// Example
/*
let alice = LegacyUser.init(withUserID: "aaaaaa1")
    let bob = LegacyUser.init(withUserID: "aaaaaa2")

    let accepted = alice.initiateConversation(withUser: bob)

    if accepted {
        alice.sendMessage("Hello there")
        bob.sendMessage("Test message")
        alice.sendMessage("Another test message")
    }
 */

class LegacyUser {
    public var publicKey : SecKey?
    private var privateKey : SecKey?
    private var recipient : LegacyUser?
    
    init(withUserID id : String) {
        //if let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, [.privateKeyUsage /*, .userPresence] authentication UI to get the private key */], nil) //Force store only if passcode or Touch ID set up...
        if let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, [.privateKeyUsage], nil)  //Keep private key on device
        {
            let privateTagString = "com.example.privateKey." + id
            let privateTag = privateTagString.data(using: .utf8)! //Store it as Data, not as a String
            let privateKeyParameters : [String : AnyObject] = [kSecAttrIsPermanent as String : true as AnyObject,
                                                               kSecAttrAccessControl as String : access as AnyObject,
                                                               kSecAttrApplicationTag as String : privateTag as AnyObject,
            ]
            
            let publicTagString = "com.example.publicKey." + id
            let publicTag = publicTagString.data(using: .utf8)! //Data, not String
            let publicKeyParameters : [String : AnyObject] = [kSecAttrIsPermanent as String : false as AnyObject,
                                                              kSecAttrApplicationTag as String : publicTag as AnyObject,
            ]
            
            let keyPairParameters : [String : AnyObject] = [kSecAttrKeySizeInBits as String : 256 as AnyObject,
                                                            kSecAttrKeyType as String : kSecAttrKeyTypeEC,
                                                            kSecPrivateKeyAttrs as String : privateKeyParameters as AnyObject,
                                                            kSecAttrTokenID as String : kSecAttrTokenIDSecureEnclave as AnyObject, //Store in Secure Enclave
                                                            kSecPublicKeyAttrs as String : publicKeyParameters as AnyObject]
            // MARK: 'SecKeyGeneratePair' was deprecated in iOS 15.0: Use SecKeyCreateRandomKey
            let status = SecKeyGeneratePair(keyPairParameters as CFDictionary, &publicKey, &privateKey)
            if status != noErr
            {
                print("Key generation error")
            }
        }
    }
    
    private func sha512Digest(forData data : Data) -> Data {
        let len = Int(CC_SHA512_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<UInt8>.allocate(capacity: len)
        CC_SHA512((data as NSData).bytes, CC_LONG(data.count), digest)
        return NSData(bytesNoCopy: UnsafeMutableRawPointer(digest), length: len) as Data
    }
    
    public func initiateConversation(withUser user : LegacyUser) -> Bool {
        var success = false
        if publicKey != nil {
            user.receiveInitialization(self)
            recipient = user
            success = true
        }
        return success
    }
    
    public func receiveInitialization(_ user : LegacyUser) {
        recipient = user
    }
    
    public func sendMessage(_ message : String) {
        if let data = message.data(using: .utf8)
        {
            let signature = self.signData(plainText: data)
            if signature != nil {
                self.recipient?.receiveMessage(message, withSignature: signature!)
            }
        }
    }
    
    public func receiveMessage(_ message: String, withSignature signature : Data) {
        let signatureMatch = verifySignature(plainText: message.data(using: .utf8)!, signature: signature)
        if signatureMatch {
            print("Received message. Signature verified. Message is : ", message)
        }
        else
        {
            print("Received message. Signature error.")
        }
    }
    
    
    func signData(plainText: Data) -> Data? {
        guard privateKey != nil else
        {
            print("Private key unavailable")
            return nil
        }
        
        let digestToSign = self.sha512Digest(forData: plainText)
        let signature = UnsafeMutablePointer<UInt8>.allocate(capacity: 512) //512 - overhead
        var signatureLength = 512
        
        // MARK: 'SecKeyRawSign' was deprecated in iOS 15.0: Use SecKeyCreateSignature
        let status = SecKeyRawSign(privateKey!, .PKCS1SHA512, [UInt8](digestToSign), Int(CC_SHA512_DIGEST_LENGTH), signature, &signatureLength)
        if status != noErr
        {
            print("Signature fail: \(status)")
            
        }
        
        return Data.init(bytes: signature, count: signatureLength) //resize to actual signature size
    }
    
    func verifySignature(plainText: Data, signature: Data) -> Bool {
        guard recipient?.publicKey != nil else {
            print("Recipient public key unavailable")
            return false
        }
        
        let digestToVerify = self.sha512Digest(forData: plainText)
        let signedHashBytesSize = signature.count
        
        // MARK: 'SecKeyRawVerify' was deprecated in iOS 15.0: Use SecKeyVerifySignature
        let status = SecKeyRawVerify(recipient!.publicKey!, .PKCS1SHA512, [UInt8](digestToVerify), Int(CC_SHA512_DIGEST_LENGTH), [UInt8](signature as Data), signedHashBytesSize)
        return status == noErr
    }
}
