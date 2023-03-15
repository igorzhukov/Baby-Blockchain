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
    
    public func addBlock(block: Block) -> Bool {
        let blockchainLastBlockId = blocksHistory.last?.id
        
        if blockchainLastBlockId == block.id {
            blocksHistory.append(block)
            return true
        } else {
            return false
        }
    }
}
