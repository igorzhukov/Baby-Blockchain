//
//  ViewController.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        let message = "Text to sign!"
//        let signatureService = SignatureService()
//
//        do {
//            let keyPair = try signatureService.createECCKeyPair()
//
//            let signature = try signatureService.sign(textToSign: message,
//                                                      privateKey: keyPair.privateKey)
//
//            let signatureIsVerified = try signatureService.verifySignature(textToSign: message,
//                                                                           signature: signature,
//                                                                           publicKey: keyPair.publicKey)
//            print(signatureIsVerified)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//
//        let hashService = HashService()
//        let data = message.data(using: .utf8)!
//        let hash1 = hashService.sha512Digest(forData: data)
//        let hash2 = hashService.sha512Digest(forData: data)
//
//        if hash1 == hash2 {
//            print("Has is the same")
//        }
        
        build()
    }
    
    func build() {
        
        
        let hashService = HashService()
        let signatureService = SignatureService()
        
        let keyPair1 = try! signatureService.createECCKeyPair()
        let keyPair2 = try! signatureService.createECCKeyPair()
        
        let wallet1 = Wallet(keyPair: keyPair1)
        let wallet2 = Wallet(keyPair: keyPair1)
        
        let account1 = Account(id: "1", publicKeys: [keyPair1.publicKey], balance: 100)
        let accoun2 = Account(id: "2", publicKeys: [keyPair2.publicKey], balance: 20)
        
        let operation1Amount = 2
        let operation1TextToSign = account1.id + accoun2.id + String(operation1Amount)
        
        let operation1Signature = try! signatureService.sign(textToSign: operation1TextToSign, privateKey: wallet1.keyPair.privateKey)
        let operation1 = Operation(sender: account1, receiver: accoun2, amount: 2, signature: operation1Signature)
        
        let transaction1 = Transaction(operations: [operation1], hashService: HashService())
        
        
    }
}
