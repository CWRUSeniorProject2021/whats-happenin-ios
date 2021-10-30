//
//  ProfileView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI

struct ProfileView: View {
   
    var body: some View {
        VStack {
            Text("Profile")
            Spacer()
            Buttons()
        }
        .navigationTitle("Profile")
        
    }
    }

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
