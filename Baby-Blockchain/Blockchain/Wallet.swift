//
//  Wallet.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation

final class Wallet {
    init(keyPair: KeyPair) {
        self.keyPair = keyPair
    }
    
    let keyPair: KeyPair
    
    func createTransaction() {
        
    }
    
    // a function that accesses the transaction history of the current wallet, calculates the current balance and returns as a number. Or makes an appropriate request to the full node of the network to obtain the current balance by accountID.
    func getBalance() {
        
    }
    
    // a function that receives transaction (or any other data), private key and returns the signature for that data.

    func signTransaction() {
        
    }
    
    // that function gets the params (like receiver ID, amount to pay) and forms the body of the transaction, also signs that transaction body and sends it to some full node in the network.
    func createOperation() {
        
    }
}
