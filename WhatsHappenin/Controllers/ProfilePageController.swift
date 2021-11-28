//
//  ProfilePageController.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 10/31/21.
//

import Foundation
import Siesta
import CoreLocation

class ProfilePageController: ObservableObject, ResourceObserver { // Should we keep? --> ResourceObserver {
    @Published var myProfile : MyProfile?
    static let sharedInstance = ProfilePageController()
    
    init() {
        WHAPI.sharedInstance.myProfile.addObserver(self)
        loadMyProfile()
    }
    
    func loadMyProfile() {
        WHAPI.sharedInstance.myProfile.load()
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        switch (resource) {
        // Handle nearby
        case WHAPI.sharedInstance.myProfile:
            if let result: MyProfile = resource.typedContent() {
                myProfile = result
            }
            
        default:
            break
        }
        
        print(resource)
        print(event)
        
    }
}
