//
//  Node.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation

final class Node {
    
    init(blockchain: Blockchain) {
        self.blockchain = blockchain
    }
    
    private let blockchain: Blockchain
    
    public func validateAndApplyTransactionsToBlockchain(_ transactions: [Transaction]) -> Bool {
        let block = Block(
            previousBlockId: blockchain.blocksHistory.last?.id,
            transactions: transactions,
            hashService: HashService()
        )
        
        let result = blockchain.appendBlock(block: block)
        return result
    }
}
