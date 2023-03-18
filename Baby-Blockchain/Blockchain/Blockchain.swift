//
//  Blockchain.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation

final class Blockchain {
    init() {
        let genesisBlock = Block(previousBlockId: nil,
                                 transactions: [],
                                 hashService: HashService())
        self.blocksHistory = []
        self.blocksHistory.append(genesisBlock)
    }
    
    private(set) var blocksHistory: [Block]
    
    public func appendBlock(block: Block) -> Bool {
        let integrity = checkIntegrity(of: block)
        
        if integrity {
            blocksHistory.append(block)
            return true
        } else {
            return false
        }
    }
    
    private func checkIntegrity(of newBlock: Block) -> Bool {
        let lastBlockId = blocksHistory.last?.id
        return lastBlockId == newBlock.previousBlockId
    }
}
