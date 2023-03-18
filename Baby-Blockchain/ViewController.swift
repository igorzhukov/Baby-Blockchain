//
//  ViewController.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.02.2023.
//

import UIKit

typealias DigitalSignature = Data

final class ViewController: UIViewController {

    private let signatureService = SignatureService()
    private let hashService = HashService()
    
    private var userApplication: UserApplication!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       userApplication = buildUserApplication()
        
       let receiver = getReceiverAccount()
       userApplication.createSendTransaction(receiver: receiver, amount: 2)
    }
    
    private func getReceiverAccount() -> Account {
        let keyPair = try! signatureService.createECCKeyPair()
        let account = Account(id: "2", publicKey: keyPair.publicKey, balance: 20)
        return account
    }
    
    private func buildUserApplication() -> UserApplication {
        
        let keyPair = try! signatureService.createECCKeyPair()
        let account = Account(id: "1", publicKey: keyPair.publicKey, balance: 100)
        let wallet = Wallet(keyPair: keyPair, account: account, signatureService: signatureService, hashService: hashService)
        
        let blockchain = Blockchain()
        let node = Node(blockchain: blockchain, signatureService: signatureService)
         
        let userApplication = UserApplication(wallet: wallet, node: node)
        
        return userApplication
    }
}
