//
//  Node.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation

struct NodeTransaction {
    let transaction: Transaction
    let transactionSignature: DigitalSignature
    let publicKey: SecKey
}

final class Node {
    
    init(blockchain: Blockchain, signatureService: SignatureService) {
        self.blockchain = blockchain
        self.signatureService = signatureService
    }
    
    private let signatureService: SignatureService
    private let blockchain: Blockchain
    
    public func verifyAndApplyTransactionsToBlockchain(_ transactions: [NodeTransaction]) -> Bool {
        
        let verifiedTransactions = transactions
            .filter { verifyTransactionSignature($0) }
            .map { $0.transaction }
        
        let block = Block(
            previousBlockId: blockchain.blocksHistory.last?.id,
            transactions: verifiedTransactions,
            hashService: HashService()
        )
        
        let result = blockchain.appendBlock(block: block)
        return result
    }
    
    private func verifyTransactionSignature(_ transaction: NodeTransaction) -> Bool {
        do {
           return try signatureService.verifySignature(dataToVerify: transaction.transaction.id, signature: transaction.transactionSignature, publicKey: transaction.publicKey)
        } catch {
            return false
        }
       
    }
}
