//
//  Block.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation

struct Block {
    /// the hash value from all other data
    let id: Data
    
    ///an identifier of the previous block (it is needed to ensure history integrity check).
    let previousBlockHash: Data
    
    ///a list of transactions confirmed in this block.
    let transactions: [Transaction]
}
