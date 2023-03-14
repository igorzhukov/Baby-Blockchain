//
//  Transaction.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 07.03.2023.
//

import Foundation

struct Transaction {
    
    // TODO: make HashService as protocol
    init(operations: [Operation], hashService: HashService) {
        self.operations = operations
        self.nonce = UInt.random(in: 0...UInt.max)
        
        var dataToHash = Data()
        
        dataToHash.append(String(nonce).data(using: .utf8)!)
        
        operations
            .map { $0.hash() }
            .forEach { dataToHash.append($0) }
        
        self.id = hashService.sha512Digest(forData: dataToHash)
    }
    
    /// a hash value from all other fields of the transaction
    let id: Data
    // a value to protect duplicate transactions with the same operations.
    let nonce: UInt
    
    let operations: [Operation]
    
}
