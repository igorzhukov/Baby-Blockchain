//
//  Account.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 07.03.2023.
//

import Foundation

struct Account {
    public let id: String
    public let publicKey: SecKey
    private(set) var balance: UInt = 0
    
    init(id: String,
         publicKey: SecKey,
         balance: UInt) {
        self.id = id
        self.publicKey = publicKey
        self.balance = balance
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
