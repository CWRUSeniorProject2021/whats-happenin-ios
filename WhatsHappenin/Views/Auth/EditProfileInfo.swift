//
//  EditProfileInfo.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 11/28/21.
//

import SwiftUI

struct EditProfileInfo: View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode

    @State var showAlert = false
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var userName = ""
    @State private var email = ""
    @State private var schoolName = ""
    
    var body: some View {
        Form{
            Section(header: Text("Profile Information")){
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Username", text: $userName)
                TextField("Email Address", text: $email)
            }
        }
        Button {
            print("Save Changes Tapped")
            // If saved changes successful, do the presentationMode.wrappedValue.dismiss(), else do a popup error
            self.presentationMode.wrappedValue.dismiss()
        }
        label : {
            Text("Save Changes")
                .bold()
                .frame(width: 260, height: 50)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding(.bottom, 10)
        .navigationBarTitle("Edit Profile", displayMode: .inline)
    }
}

struct EditProfileInfo_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileInfo()
    }
}
