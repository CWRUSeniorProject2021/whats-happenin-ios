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
            
//                $0.decorateRequests {
//                    self.refreshTokenOnAuthFailure(request: $1)
//                }
        }
        
        configure(whenURLMatches: { $0 != self.signInResource.url }, description: "Catch auth failures") {
            $0.decorateRequests {_, req in
                req.onFailure{ error in
                    if error.httpStatusCode == 401 {
                        self.clearAuthDetails()
                    }
                }
            }
        }
        
        configureTransformer("/events/*/rsvp") {
            try self.jsonDecoder.decode(GenericResponse<SingleEvent>.self, from: $0.content).data.event
        }
        
        configureTransformer("/events/*", requestMethods: [.post, .patch, .get]) {
            try self.jsonDecoder.decode(GenericResponse<SingleEvent>.self, from: $0.content).data.event
        }
        
        configureTransformer("/events/*", requestMethods: [.delete]) {
            try self.jsonDecoder.decode(GenericResponse<Empty>.self, from: $0.content)
        }

        configureTransformer("/events/nearby") {
            try self.jsonDecoder.decode(GenericResponse<EventList>.self, from: $0.content).data.events
        }
        
        configureTransformer("/events/past") {
            try self.jsonDecoder.decode(GenericResponse<EventList>.self, from: $0.content).data.events
        }
        
        configureTransformer("/events/upcoming") {
            try self.jsonDecoder.decode(GenericResponse<EventList>.self, from: $0.content).data.events
        }
        
        configureTransformer("/events/mine") {
             try self.jsonDecoder.decode(GenericResponse<EventList>.self, from: $0.content).data.events
         }
        
        configureTransformer("/users/myprofile") {
            try self.jsonDecoder.decode(GenericResponse<MyProfile>.self, from: $0.content).data
         }
        
        configureTransformer("/auth") {
            try self.jsonDecoder.decode(GenericResponse<LoginProfile>.self, from: $0.content)
         }
        
        configureTransformer("/users") {
            try self.jsonDecoder.decode(GenericResponse<UserProfile>.self, from: $0.content).data
         }

        self.invalidateConfiguration()
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
        let hasCreds = ((authDetails["email"] ?? "") != "") && ((authDetails["password"] ?? "") != "")

        return request.chained {
            print(request)
            guard case .failure(let error) = $0.response,  // Did request fail…
                  error.httpStatusCode == 401 && hasCreds else {           // …because of expired token?
                      return .useThisResponse                    // If not, use the response we got.
                  }
            
            return .passTo(
                self.login().chained { // If so, first request a new token, then:
                    if case .failure = $0.response { // If token request failed…
                        self.clearAuthDetails()
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
        print("Attempting login")
        return signInResource
            .request(.post, json: authDetails)
            .onSuccess {
                print("login success")
                self.authToken = $0.headers[Keys.Auth.Token]
                self.authTokenType = $0.headers[Keys.Auth.TokenType]
                self.authClient = $0.headers[Keys.Auth.Client]
                self.authUID = $0.headers[Keys.Auth.UID]
                self.invalidateConfiguration()                    // …make future requests use it
                ProfilePageController.sharedInstance.loadMyProfile()
            }
            .onFailure { _ in
                print("login failed")
                self.clearAuthDetails()
            }
    }
    
    /**
     * Perform logout request
     */
    func logout() -> Request {
        self.clearAuthDetails()
        return signOutResource
            .request(.delete)
            .onFailure { _ in
                print("Failed to logout")
            }
    }
    
    /**
     * Clears auth details from keychain storage
     */
    func clearAuthDetails() {
        print("Clearing auth")
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
    var myProfile: Resource { return resource("/users/myprofile")}
    var users: Resource { return resource("/users") }

    var events: Resource { return resource("/events") }
    var nearbyEvents: Resource { return resource("/events/nearby") }
    var yourEvents: Resource { return resource("/events/mine") }
    var pastEvents: Resource { return resource("/events/past") }
    var upcomingEvents: Resource { return resource("/events/upcoming") }
    
    func parseErrors<T: Codable>(_ response: RequestError) -> GenericResponse<T>? {
        if let errorData: Data = response.typedContent(){
            do {
                let content = try jsonDecoder.decode(GenericResponse<T>.self, from: errorData)
                return content
            } catch {
               print(error)
            }
        }
        return nil
    }
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

struct Empty: Hashable, Codable {
    
}
