//
//  Transaction.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 07.03.2023.
//

import Foundation

struct Transaction {
    
    init(operations: [Operation], hashService: HashService) {
        self.operations = operations
        self.nonce = UInt.random(in: 0...UInt.max)
        
        var dataToHash = Data()
        
        /// append `nonce` as Data into `dataToHash
        dataToHash.append(String(nonce).data(using: .utf8)!)
        
        operations
            .map { $0.hash() } // map to array of Operation hashes
            .forEach { dataToHash.append($0) } /// append each Operation hash into `dataToHash`
        
        self.id = hashService.sha512Digest(forData: dataToHash)
    }
    
    /// a hash value from all other fields of the transaction
    let id: Data
    // a value to protect duplicate transactions with the same operations.
    let nonce: UInt
    
    let operations: [Operation]
    
}
