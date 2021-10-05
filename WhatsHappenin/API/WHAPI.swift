//
//  WHAPI.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation
import Siesta
import KeychainSwift

class WHAPI: Service {
    enum Keys {
        enum Auth {
            static let Token : String! = "access-token"
            static let TokenType : String! = "token-type"
            static let Client : String! = "client"
            static let UID : String! = "uid"
        }
    }
    
    var authToken: String?? {
        didSet {
            //GlobalKeychain.set(authToken, forKey: Keys.Auth.Token)
            //GlobalKeychain.set
        }
    }
    var authTokenType: String?? {
        didSet {
            //GlobalKeychain.set(authTokenType, forKey: Keys.Auth.TokenType)
        }
    }
    var authClient: String??
    var authUID: String??
//    var authToken: String? {
//        didSet {
//            invalidateConfiguration()
//            wipeResources()
//        }
//    }
//    var authTokenType: String? {
//        didSet{
//            invalidateConfiguration()
//            wipeResources()
//        }
//    }
//    var authClient: String? {
//        didSet{
//            invalidateConfiguration()
//            wipeResources()
//        }
//    }
//    var authUID: String? {
//        didSet{
//            invalidateConfiguration()
//            wipeResources()
//        }
//    }
    
    
    init() {
        print("init called")
        super.init(baseURL: Environment.rootURLString + "/" + Environment.apiVersion)
        print(Environment.rootURLString + "/" + Environment.apiVersion)
        
        configure("**", description: "API Auth") {
            if let authToken = self.authToken {
                $0.headers[Keys.Auth.Token] = authToken
            }
            if let authTokenType = self.authTokenType {
                $0.headers[Keys.Auth.TokenType] = authTokenType
            }
            if let authClient = self.authClient {
                $0.headers[Keys.Auth.TokenType] = authClient
            }
            if let authUID = self.authUID {
                $0.headers[Keys.Auth.UID] = authUID
            }
            
            $0.decorateRequests {
                self.refreshTokenOnAuthFailure(request: $1)
            }
        }
    }
    
    func refreshTokenOnAuthFailure(request: Request) -> Request {
      return request.chained {
        guard case .failure(let error) = $0.response,  // Did request fail…
          error.httpStatusCode == 401 else {           // …because of expired token?
            return .useThisResponse                    // If not, use the response we got.
        }

        return .passTo(
          self.login().chained {             // If so, first request a new token, then:
            if case .failure = $0.response {           // If token request failed…
              return .useThisResponse                  // …report that error.
            } else {
              return .passTo(request.repeated())       // We have a new token! Repeat the original request.
            }
          }
        )
      }
    }

    func login() -> Request {
        return signInResource
            .request(.post, json: userAuthData())
            .onSuccess {
                print("success request")
                self.authToken = $0.headers[Keys.Auth.Token]
                self.authTokenType = $0.headers[Keys.Auth.TokenType]
                self.authClient = $0.headers[Keys.Auth.Client]
                self.authUID = $0.headers[Keys.Auth.UID]
                self.invalidateConfiguration()                    // …make future requests use it
            }
    }

    private func userAuthData() -> [String: String] {
        let email = GlobalKeychain.get("email") ?? ""
        let password = GlobalKeychain.get("password") ?? ""
        return ["email": email,
                "password": password]
    }
    
    var signInResource: Resource { return resource("/auth/sign_in") }
    var events: Resource { return resource("/events") }
}

let whAPI = WHAPI()
