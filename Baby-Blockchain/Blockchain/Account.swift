//
//  Account.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 07.03.2023.
//

import Foundation

struct Account {
    let id: UUID
    private var publicKeys: [SecKey]
    private(set) var balance: UInt
    
    public func addPublicKeyToAccount(_ publicKey: SecKey) {
        publicKeys.append(publicKey)
    }
    
    public func updateBalance(with balance: UInt) {
        publicKeys.append(publicKey)
    }
}
