//
//  Data+Digest.swift
//  TrailforksKitTests
//
//  Created by Arthur Dexter on 2/24/21.
//

import CommonCrypto
import Foundation

extension Data {

    var sha1: Data? {
        var digest = Data(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        digest.withUnsafeMutableBytes { (digestBytes: UnsafeMutableRawBufferPointer) in
            withUnsafeBytes { [count = self.count] (bytesToDigest) in
                let dst = digestBytes.baseAddress?.assumingMemoryBound(to: UInt8.self)
                _ = CC_SHA1(bytesToDigest.baseAddress, CC_LONG(count), dst)
            }
        }
        return digest
    }

    var hexString: String {
        var result = String()
        for byte in self {
            result.append(String(format: "%02x", byte))
        }
        return result
    }
}
