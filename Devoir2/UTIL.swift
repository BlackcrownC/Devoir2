//
//  UTIL.swift
//  Devoir2
//
//  Created by Mac11 on 2021-05-05.
//

import Foundation
import BCryptSwift

public func encrypt(passwd: String) -> String {
    let salt = BCryptSwift.generateSalt()
    return BCryptSwift.hashPassword(passwd, withSalt: salt)!
}

public func verifyPassword(passwd: String, hash: String) -> Bool {
    return BCryptSwift.verifyPassword(passwd, matchesHash: hash)!
}

public func isAnEmail(email: String) -> Bool {
    let range = NSRange(location: 0, length: email.utf16.count)
    let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    if(regex.firstMatch(in: email, options: [], range: range) == nil) {
        return false
    }
    return true
}

public var connectedUser: String = ""
