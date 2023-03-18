//
//  HashService.swift
//  Baby-Blockchain
//
//  Created by Igor Zhukov on 14.03.2023.
//

import Foundation
import CommonCrypto

final class HashService {
    
    func sha512Digest(forData data: Data) -> Data {
        let lenght = Int(CC_SHA512_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<UInt8>.allocate(capacity: lenght)
        CC_SHA512((data as NSData).bytes, CC_LONG(data.count), digest)
        return NSData(bytesNoCopy: UnsafeMutableRawPointer(digest), length: lenght) as Data
    }
}
