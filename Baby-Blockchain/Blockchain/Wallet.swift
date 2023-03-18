//
//  Wallet.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation

final class Wallet {
    
    init(
        keyPair: KeyPair,
        account: Account,
        signatureService: SignatureService,
        hashService: HashService
    ) {
        self.keyPair = keyPair
        self.account = account
        self.signatureService = signatureService
        self.hashService = hashService
    }
    
    private var transactionsHistory: [Transaction] = []
    private let keyPair: KeyPair
    private let account: Account
    private let signatureService: SignatureService
    private let hashService: HashService
    
    public func createSendTransaction(receiver: Account, amount: UInt) -> Transaction? {
        let operationTextToSign = account.id + receiver.id + String(amount)
        
        /// sign 1 Operation data
        let operationSignature = try! signatureService.sign(textToSign: operationTextToSign, privateKey: keyPair.privateKey)
        
        /// init 1 Operation
        let operation = Operation(sender: account,
                                   receiver: receiver,
                                   amount: amount,
                                   signature: operationSignature)
        
        guard operation.isValid() else { return nil }
        
        /// init 1 Transaction
        let transaction = Transaction(operations: [operation], hashService: HashService())
        
        transactionsHistory.append(transaction)
        return transaction
    }
    
    /*
    // a function that accesses the transaction history of the current wallet, calculates the current balance and returns as a number. Or makes an appropriate request to the full node of the network to obtain the current balance by accountID.
    public func getBalance() {
//        let operations = transactionsHistory.flatMap { $0.operations}
    }
    
    // a function that receives transaction (or any other data), private key and returns the signature for that data.
    public func signTransaction() {
        
    }
    
    // that function gets the params (like receiver ID, amount to pay) and forms the body of the transaction, also signs that transaction body and sends it to some full node in the network.
    public func createOperation() {
        
    }
     */
}
