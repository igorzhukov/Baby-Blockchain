//
//  UserApplication.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation

final class UserApplication {
    
    init(wallet: Wallet, node: Node) {
        self.wallet = wallet
        self.node = node
    }
    
    private let wallet: Wallet
    private let node: Node
}
