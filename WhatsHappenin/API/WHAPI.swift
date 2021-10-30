//
//  WHAPI.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 10/5/21.
//

import Foundation
//import KeychainSwift
//import Alamofire

//class WHAPI {
//
//    let headers: HTTPHeaders = [
//        .accept("application/json")
//    ]
//
//    init() {
//        print("hi")
//        AF.request("https://httpbin.org/get").response { response in
//            print("\(response)")
//            debugPrint("Response: \(response)")
//        }
//    }
//
//    func login(username: String, password: String) {
//        AF.request("")
//    }
//
//    func printhi() {
//        print("hi")
//    }
//
//}
//
//let whAPI = WHAPI()


import Siesta
import KeychainSwift

class WHAPI: Service {
    static let sharedInstance = WHAPI()

    enum Keys {
        enum Auth {
            static let Token : String! = "access-token"
            static let TokenType : String! = "token-type"
            static let Client : String! = "client"
            static let UID : String! = "uid"
        }
    }

    let jsonDecoder = JSONDecoder()

    var authToken: String?? {
        didSet {
            GlobalKeychain.set((authToken as? String) ?? "", forKey: Keys.Auth.Token)
        }
    }
    var authTokenType: String?? {
        didSet {
            GlobalKeychain.set((authTokenType as? String) ?? "", forKey: Keys.Auth.TokenType)
        }
    }
    var authClient: String?? {
        didSet {
            GlobalKeychain.set((authClient as? String) ?? "", forKey: Keys.Auth.Client)
        }
    }
    var authUID: String?? {
        didSet {
            GlobalKeychain.set((authUID as? String) ?? "", forKey: Keys.Auth.UID)
        }
    }

    private init() {
        super.init(baseURL: Environment.rootURLString + "/" + Environment.apiVersion, standardTransformers: [.text, .image])
        
        SiestaLog.Category.enabled = [.network, .pipeline, .observers]

        configure("**", description: "API Auth") {
            //print("In Auth Func ---> Token: \(self.authToken)   Token Type: \(self.authTokenType)   Client: \(self.authClient)  UID: \(self.authUID)")
            if let authToken = self.authToken {
                $0.headers[Keys.Auth.Token] = authToken
            }
            if let authTokenType = self.authTokenType {
                $0.headers[Keys.Auth.TokenType] = authTokenType
            }
            if let authClient = self.authClient {
                $0.headers[Keys.Auth.Client] = authClient
            }
            if let authUID = self.authUID {
                $0.headers[Keys.Auth.UID] = authUID
            }

            print($0.headers)

            $0.decorateRequests {
                self.refreshTokenOnAuthFailure(request: $1)
            }
        }

        configureTransformer("/events/nearby") {
            try self.jsonDecoder.decode(GenericResponse<EventList>.self, from: $0.content).data.events
        }
    }

    /**
     * If the token is invalid during a request, attempt to reauthenticate with the saved username and password
     */
    func refreshTokenOnAuthFailure(request: Request) -> Request {
      return request.chained {
        guard case .failure(let error) = $0.response,  // Did request fail…
          error.httpStatusCode == 403 else {           // …because of expired token?
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

    /**
     * Perform a login request
     */
    func login() -> Request {
        return signInResource
            .request(.post, json: userAuthData())
            .onSuccess {
                self.authToken = $0.headers[Keys.Auth.Token]
                self.authTokenType = $0.headers[Keys.Auth.TokenType]
                self.authClient = $0.headers[Keys.Auth.Client]
                self.authUID = $0.headers[Keys.Auth.UID]
                //print("In Login Func ---> Token: \(self.authToken)   Token Type: \(self.authTokenType)   Client: \(self.authClient)  UID: \(self.authUID)")
                self.invalidateConfiguration()                    // …make future requests use it
            }
            .onFailure { _ in
                self.authToken = ""
                self.authTokenType = ""
                self.authClient = ""
                self.authUID = ""
                GlobalKeychain.set("", forKey: "email")
                GlobalKeychain.set("", forKey: "password")
            }
    }

    /**
     * Obtain the stored auth parameters from the keychain
     */
    private func userAuthData() -> [String: String] {
        let email = GlobalKeychain.get("email") ?? ""
        let password = GlobalKeychain.get("password") ?? ""
        return ["email": email,
                "password": password]
    }

    var signInResource: Resource { return resource("/auth/sign_in") }

//    func nearbyEvents(_ coordinates: CoordinatePair, range: Float = 5.0) -> Resource {
//        return resource("/events/nearby")
//
//    }
    var nearbyEvents: Resource {
        return resource("/events/nearby")
    }
    
    var events: Resource {
        return resource("/events")
    }
    
    var auth: Resource {
        return resource("/auth")
    }
}


extension WHAPI {
//    func nearbyEvents(coordinates: CoordinatePair, range: float = 5.0) {
//        self.events.loadIfNeeded()
//    }
}


