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
    static let sharedInstance = WHAPI()

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
        
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        initializeAuthDetails()
        
        SiestaLog.Category.enabled = [.network, .pipeline, .observers]

        configure("**", description: "API Auth") {
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
            
            $0.decorateRequests {
                self.refreshTokenOnAuthFailure(request: $1)
            }
        }
        
        configureTransformer("/events/*/rsvp") {
            try self.jsonDecoder.decode(GenericResponse<SingleEvent>.self, from: $0.content).data.event
        }

        configureTransformer("/events/nearby") {
            try self.jsonDecoder.decode(GenericResponse<EventList>.self, from: $0.content).data.events
        }
        
        configureTransformer("/events/mine") {
             try self.jsonDecoder.decode(GenericResponse<EventList>.self, from: $0.content).data.events
         }
    }
    
    private func initializeAuthDetails() {
        authToken = GlobalKeychain.get(Keys.Auth.Token) ?? ""
        authTokenType = GlobalKeychain.get(Keys.Auth.TokenType) ?? ""
        authClient = GlobalKeychain.get(Keys.Auth.Client) ?? ""
        authUID = GlobalKeychain.get(Keys.Auth.UID) ?? ""
    }

    /**
     * If the token is invalid during a request, attempt to reauthenticate with the saved username and password
     */
    func refreshTokenOnAuthFailure(request: Request) -> Request {
        let authDetails = self.userAuthData()
        let hasCreds = (authDetails["email"]) ?? "" != "" && (authDetails["password"] ?? "") != ""

        return request.chained {
            guard case .failure(let error) = $0.response,  // Did request fail…
                  error.httpStatusCode == 401 && hasCreds else {           // …because of expired token?
                      return .useThisResponse                    // If not, use the response we got.
                  }
            
            return .passTo(
                self.login().chained {             // If so, first request a new token, then:
                    if case .failure = $0.response { // If token request failed…
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
    func login(username: String = "", password: String = "") -> Request {
        var authDetails = [String : String]()
        if (username != "" || password != "") {
            authDetails["email"] = username
            authDetails["password"] = password
        } else {
            authDetails = userAuthData()
        }
        
        return signInResource
            .request(.post, json: authDetails)
            .onSuccess {
                self.authToken = $0.headers[Keys.Auth.Token]
                self.authTokenType = $0.headers[Keys.Auth.TokenType]
                self.authClient = $0.headers[Keys.Auth.Client]
                self.authUID = $0.headers[Keys.Auth.UID]
                self.invalidateConfiguration()                    // …make future requests use it
            }
            .onFailure { _ in
                self.clearAuthDetails()
            }
    }
    
    /**
     * Perform logout request
     */
    func logout() -> Request {
        return signOutResource
            .request(.delete)
            .onSuccess { _ in
                self.clearAuthDetails()
            }
            .onFailure { _ in
                print("Failed to logout")
            }
    }
    
    /**
     * Clears auth details from keychain storage
     */
    func clearAuthDetails() {
        self.authToken = ""
        self.authTokenType = ""
        self.authClient = ""
        self.authUID = ""
        GlobalKeychain.set("", forKey: "email")
        GlobalKeychain.set("", forKey: "password")
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
    var signOutResource: Resource { return resource("/auth/sign_out") }
    var auth: Resource { return resource("/auth") }

    var events: Resource { return resource("/events") }
    var nearbyEvents: Resource { return resource("/events/nearby") }
    var yourEvents: Resource { return resource("/events/mine") }
    var pastEvents: Resource { return resource("/events/past") }
    var upcomingEvents: Resource { return resource("/events/upcoming") }
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}

