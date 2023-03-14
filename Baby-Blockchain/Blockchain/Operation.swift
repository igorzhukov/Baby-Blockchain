//
//  Operation.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 07.03.2023.
//

import Foundation

struct Operation {
    let sender: Account
    let receiver: Account
    let amount: UInt
    let signature: Data
    
    func isValid() -> Bool {
        guard amount <= sender.balance else {
            return false
        }
        
        let signatureService = SignatureService()
        
        let publicKey = sender.publicKeys.first!
 
        // TODO: add message
        // TODO: signature verify
        return true
    }
}
