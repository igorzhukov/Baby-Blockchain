//
//  Transaction.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 07.03.2023.
//

import Foundation

struct Transaction {
    let transactionID: UUID
    let operations: [Operation]
    let nonce: UInt
}
