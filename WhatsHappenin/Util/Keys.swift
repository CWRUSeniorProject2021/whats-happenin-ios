//
//  Keys.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/2/21.
//

import Foundation

enum Keys {
    enum Plist {
        static let rootURL = "ROOT_URL"
        static let apiVersion = "API_VERSION"
        static let testUserUsername = "TEST_USER_USERNAME"
        static let testUserPassword = "TEST_USER_PASSWORD"
        //static let apiKey = "API_KEY"
    }
    
    enum Auth {
        static let Token : String! = "access-token"
        static let TokenType : String! = "token-type"
        static let Client : String! = "client"
        static let UID : String! = "uid"
    }
    
    enum Defaults {
        static let lastLocation = "LAST_LOCATION"
    }
}
