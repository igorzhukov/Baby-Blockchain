//
//  Block.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation

struct Block {
    init(previousBlockId: Data?, transactions: [Transaction], hashService: HashService) {
        
        self.previousBlockId = previousBlockId
        self.transactions = transactions
        
        var dataToHash = Data()
        if let previousBlockId = previousBlockId {
            dataToHash.append(previousBlockId) /// append `previousBlockId` into `dataToHash`
        }
        
        transactions
            .map { $0.id } /// map to array of Transaction hashes
            .forEach { dataToHash.append($0) } /// append each `transactionId` into `dataToHash`
        
        self.id = hashService.sha512Digest(forData: dataToHash)
    }
    
    /// the hash value from all other data
    let id: Data
    
    /// the hash of the previous block (it is needed to ensure history integrity check)
    /// can be optional for the first block
    let previousBlockId: Data?
    
    /// a list of transactions confirmed in this block.
    let transactions: [Transaction]
}
