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
    
    let wallet: Wallet
    let node: Node
    
    
    public func createSendTransaction(receiver: Account, amount: UInt) {
        guard let transaction = wallet.createSendTransaction(receiver: receiver, amount: amount) else {
            return
        }
        
        let result = node.validateAndApplyTransactionsToBlockchain([transaction])
        print(result)
    }
}
