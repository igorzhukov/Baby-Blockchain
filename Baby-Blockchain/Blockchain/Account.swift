//
//  Account.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 07.03.2023.
//

import Foundation

struct Account {
    let id: UUID
    var publicKeys: [SecKey]
    private(set) var balance: UInt
    
    public mutating func addPublicKeyToAccount(_ publicKey: SecKey) {
        publicKeys.append(publicKey)
    }
    
    public mutating func updateBalance(with balance: UInt) {
        self.balance = balance
    }
    
    public mutating func decreaseBalance(with amount: UInt) {
        balance -= amount
    }
    
    public mutating func increaseBalance(with amount: UInt) {
        balance += amount
    }
}
