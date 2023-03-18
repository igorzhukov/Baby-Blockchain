//
//  Signature.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.02.2023.
//

import Foundation
import CommonCrypto

enum SignatureError: Error {
    case noPrivateKeyInKeychain
    case signatureAlgorithmIsNotSupported(algorithm: String)
}

final class SignatureService {
    
    func createECCKeyPair () throws -> KeyPair {
        let attributes: [String: Any] =
        [
            /// only supported key type for `ECC`
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            // supported key lengths: 256, 383 and 521
            kSecAttrKeySizeInBits as String: 521,
            /*
            kSecPrivateKeyAttrs as String: [
                /// `kSecAttrIsPermanent` true is to store generated `PrivateKey` to in the default `Keychain`
                kSecAttrIsPermanent as String: true,
                /// `kSecAttrApplicationTag` attribute with a unique NSData value so that you can find and retrieve it from the keychain later. The tag data is constructed from a string, using reverse DNS notation, though any unique tag will do.
                /// let tag = "com.example.keys.mykey".data(using: .utf8)!
                kSecAttrApplicationTag as String: "TAG"
            ]
             */
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        let publicKey = SecKeyCopyPublicKey(privateKey)!
        
        return KeyPair(privateKey: privateKey, publicKey: publicKey)
    }
    
    func sign(textToSign: String, privateKey: SecKey) throws -> Data {
        let dataToSign = textToSign.data(using: .utf8)!
        return try sign(dataToSign: dataToSign, privateKey: privateKey)
    }
    
    func sign(dataToSign: Data, privateKey: SecKey) throws -> Data {
        var error: Unmanaged<CFError>?
        
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA512
        guard SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm) else {
            throw SignatureError.signatureAlgorithmIsNotSupported(algorithm: String(describing: algorithm))
        }
        
        // create the signature
        guard let signature = SecKeyCreateSignature(privateKey, algorithm, dataToSign as CFData, &error) as Data? else {
            throw error!.takeRetainedValue() as Error
        }
        
        print("Signature: " + signature.base64EncodedString())
        return signature
    }

    
    func verifySignature(textToVerify: String,
                         signature: DigitalSignature,
                         publicKey: SecKey) throws -> Bool {
        let data = textToVerify.data(using: .utf8)!
        return  try verifySignature(dataToVerify: data, signature: signature, publicKey: publicKey)
    }
    
    func verifySignature(dataToVerify: Data,
                         signature: Data,
                         publicKey: SecKey) throws -> Bool {
        var error: Unmanaged<CFError>?

        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA512
        
        // Check if selected algorithm suits the key’s capabilities.
        guard SecKeyIsAlgorithmSupported(publicKey, .verify, algorithm) else {
            throw error!.takeRetainedValue() as Error
        }
    
        let result = SecKeyVerifySignature(publicKey, algorithm, dataToVerify as CFData, signature as CFData, &error)
        
        if result {
            print("Signature is verified")
        } else {
            print("Signature is not correct")
        }
        
        return result
    }
    
    /*
    func retrievePrivateKeyFromKeychain() throws -> SecKey {
        // Create a query with key type and tag
        let getQuery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: "TAG",
                                       kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                                       kSecReturnRef as String: true]

        // Use this query with the SecItemCopyMatching method to execute a search
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw SignatureError.noPrivateKeyInKeychain
        }
        
        let privateKey = item as! SecKey

        return privateKey
    }
     */
}
