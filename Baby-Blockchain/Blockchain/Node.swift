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
    let blockchain: Blockchain
}
