//
//  Environment.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation

public enum Environment {    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    // MARK: - Plist values
    static let rootURL: URL = {
        guard let rootURLstring = Environment.infoDictionary[Keys.Plist.rootURL] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        guard let url = URL(string: rootURLstring) else {
            fatalError("Root URL is invalid")
        }
        return url
    }()
    
    static let rootURLString: String = {
        guard let URLstring = Environment.infoDictionary[Keys.Plist.rootURL] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        return URLstring
    }()
    
    static let apiVersion: String = {
        guard let version = Environment.infoDictionary[Keys.Plist.apiVersion] as? String else {
            fatalError("API Version not set in plist for this environment")
        }
        return version
    }()
    
    static let testUserUsername : String = {
        return Environment.infoDictionary[Keys.Plist.testUserUsername] as? String ?? ""
    }()
    
    static let testUserPassword : String = {
        return Environment.infoDictionary[Keys.Plist.testUserPassword] as? String ?? ""
    }()

//    static let apiKey: String = {
//        guard let apiKey = Environment.infoDictionary["API_KEY"] as? String else {
//            fatalError("API Key not set in plist for this environment")
//        }
//        return apiKey
//    }()
}
