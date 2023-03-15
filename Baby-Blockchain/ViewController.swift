//
//  ViewController.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.02.2023.
//

import UIKit


// TODO: Connection if blockchain is injected (true/false)

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testRun()
    }
    
    func testRun() {
        
        /// init Signature and Hash services
        let hashService = HashService()
        let signatureService = SignatureService()
        
        /// generate 2 KeyPairs for 2 wallets
        let keyPair1 = try! signatureService.createECCKeyPair()
        let keyPair2 = try! signatureService.createECCKeyPair()
        
        /// init 2 Wallets
        let wallet1 = Wallet(keyPair: keyPair1)
        let wallet2 = Wallet(keyPair: keyPair1)
        
        /// init 2 Accounts
        let account1 = Account(id: "1", publicKeys: [keyPair1.publicKey], balance: 100)
        let account2 = Account(id: "2", publicKeys: [keyPair2.publicKey], balance: 20)
        
        /// init 1 Operation data
        let operation1Amount = 2
        let operation1TextToSign = account1.id + account2.id + String(operation1Amount)
        
        /// sign 1 Operation data
        let operation1Signature = try! signatureService.sign(textToSign: operation1TextToSign, privateKey: wallet1.keyPair.privateKey)
        
        /// init 1 Operation
        let operation1 = Operation(sender: account1, receiver: account2, amount: 2, signature: operation1Signature)
        
        /// init 1 Transaction
        let transaction1 = Transaction(operations: [operation1], hashService: HashService())
        
        /// init 1 Blockchain
        let blockchain1 = Blockchain()
        
        let blockchainLastBlockId = blockchain1.blocksHistory.last?.id
        
        /// init 1 Block
        let block1 = Block(previousBlockId: blockchainLastBlockId, transactions: [transaction1], hashService: HashService())
        
        blockchain1.addBlock(block: block1)
    }
}
