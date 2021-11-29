//
//  EditProfileInfo.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 11/28/21.
//

import SwiftUI

struct EditProfileInfo: View {
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    @ObservedObject var controller = ProfilePageController.sharedInstance

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
            let requestData: [String: Any] = [
                "first_name": firstName,
                "last_name": lastName,
                "username": userName,
                "email": email,
            ] as [String: Any]
            WHAPI.sharedInstance.user.child("\(controller.myProfile?.id ?? 1)").request(.patch, json: requestData)
                .onSuccess { response in
                    GlobalKeychain.set(email, forKey: "email")
                    self.presentationMode.wrappedValue.dismiss()
                    self.showAlert = true
                    controller.loadMyProfile()
                }
                .onFailure { error in
//                    print(requestData.self.values)
                    print("Error \(error)")
                    Alert(
                        title: Text("Invalid Input"),
                        message: Text("Please Enter Information For All Fields"),
                        dismissButton: .default(Text("Close"))
                    )
                    // HANDLE FAILURE HERE
                }

            
        }
        label : {
            Text("Save Changes")
                .bold()
                .frame(width: 260, height: 50)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Saved Changes"),
                message: Text("Your profile information has been updated"),
                dismissButton: .default(Text("Close"))
            )
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
