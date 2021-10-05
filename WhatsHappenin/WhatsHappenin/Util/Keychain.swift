//
//  Keychain.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation
import KeychainSwift

class Keychain : KeychainSwift {
    
    override init() {
        super.init()
        self.synchronizable = true
    }
}

let GlobalKeychain = Keychain()
