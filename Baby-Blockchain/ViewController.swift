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
        
        let message = "Text to sign!"
        let signatureService = SignatureService()
        
        do {
            let keyPair = try signatureService.createECCKeyPair()
            
            let signature = try signatureService.sign(textToSign: message,
                                                      privateKey: keyPair.privateKey)
            
            let signatureIsVerified = try signatureService.verifySignature(textToSign: message,
                                                                           signature: signature,
                                                                           publicKey: keyPair.publicKey)
            print(signatureIsVerified)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
