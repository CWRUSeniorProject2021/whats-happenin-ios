//
//  ProfileView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            ShowProfilePage(isLoggedIn: $isLoggedIn)
        }
        .navigationTitle("Profile")
        
    }
    }

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
    }
}
