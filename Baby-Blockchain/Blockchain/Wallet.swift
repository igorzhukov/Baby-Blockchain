//
//  Wallet.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation


public final class Wallet {

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
    
    func createSendTransaction(receiver: Account, amount: UInt) -> NodeTransaction? {
        let operationTextToSign = account.id + receiver.id + String(amount)
        
        let operationSignature = try! signatureService.sign(textToSign: operationTextToSign, privateKey: keyPair.privateKey)
        
        let operation = Operation(sender: account,
                                   receiver: receiver,
                                   amount: amount,
                                   signature: operationSignature)
        
        guard operation.isValid() else { return nil }
        
        let transaction = Transaction(operations: [operation], hashService: HashService())
        
        transactionsHistory.append(transaction)
        
        guard let signature = signTransaction(transaction) else { return nil }
        
        return NodeTransaction(transaction: transaction, transactionSignature: signature, publicKey: keyPair.publicKey)
    }
    
    func signTransaction(_ transaction: Transaction) -> DigitalSignature? {
        return try! signatureService.sign(dataToSign: transaction.id, privateKey: keyPair.privateKey)
    }
}
