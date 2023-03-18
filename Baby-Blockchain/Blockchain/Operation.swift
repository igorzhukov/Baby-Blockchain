//
//  Operation.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 07.03.2023.
//

import Foundation

struct Operation {
    init(
         sender: Account,
         receiver: Account,
         amount: UInt,
         signature: Data,
         signatureService: SignatureService = SignatureService(),
         hashService: HashService = HashService()
    ) {
        self.sender = sender
        self.receiver = receiver
        self.amount = amount
        self.signature = signature
        self.signatureService = signatureService
        self.hashService = hashService
    }
    
    let sender: Account
    let receiver: Account
    let amount: UInt
    let signature: Data
    private let hashService: HashService
    private let signatureService: SignatureService
    
    func isValid() -> Bool {
        guard amount <= sender.balance else {
            return false
        }
        
        let publicKey = sender.publicKey
        
 
        // TODO: add message
        // TODO: signature verify
        return true
    }
    
    func hash() -> Data {
        let senderData = sender.id.data(using: .utf8)!
        let receiverData = receiver.id.data(using: .utf8)!
        let amountData = String(amount).data(using: .utf8)!
        var dataToHash = Data()
        dataToHash.append(senderData)
        dataToHash.append(receiverData)
        dataToHash.append(amountData)
        
        return hashService.sha512Digest(forData: dataToHash)
    }
}
