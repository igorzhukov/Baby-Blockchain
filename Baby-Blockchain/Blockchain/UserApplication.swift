//
//  UserApplication.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation

final class UserApplication {
    init(wallet: Wallet) {
        self.wallet = wallet
    }
    let wallet: Wallet
}
