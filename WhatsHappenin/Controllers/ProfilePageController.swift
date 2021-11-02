//
//  ProfilePageController.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 10/31/21.
//

import Foundation
import Siesta
import CoreLocation

class ProfilePageController: ObservableObject { // Should we keep? --> ResourceObserver {
    var profilePageResource: Resource// [String : String]
    let username = LoginView().username
//    let user = WHAPI.sharedInstance.auth.request()
    
//    let lastName = RegistrationView().lastName
//    let emailAddr = RegistrationView().emailAddr
//    let standing = RegistrationView().standing
    init() {
        profilePageResource = WHAPI.sharedInstance.signInResource//.userAuthData()
    }

    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        print("hit resource changed")
    }

    func printProfile() {
//        print("\(username) and \(firstName) \(lastName) and \(emailAddr) and \(standing)")
    }
}

let profilePageController = ProfilePageController()
