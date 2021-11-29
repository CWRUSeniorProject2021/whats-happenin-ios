//
//  RegistrationView.swift
//  WhatsHappenin
//
//  Created by Prithik Karthikeyan on 9/19/21.
//

import SwiftUI
import CoreData
import Siesta

struct RegistrationView : View {
    
    @SwiftUI.Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var showAlert = false
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var userName = ""
    @State private var password1 = ""
    @State private var password2 = ""
    @State private var emailAddr = ""
    @State private var gender = ""
    @State private var standing = ""
    @State private var birthDate = Date()
    @State private var alertTitle : String = ""
    @State private var alertMessage : String = ""
    
    enum Gender: String, CaseIterable, Identifiable {
            case male
            case female
            case other

            var id: String { self.rawValue }
        }
    
    enum Standing: String, CaseIterable, Identifiable {
            case Freshman
            case Sophomore
            case Junior
            case Senior
            case Other

            var id: String { self.rawValue }
        }

    
    
    var body: some View {
        Form{
            Section(header: Text("Account Information")){
                TextField("Email Address", text: $emailAddr)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                SecureField("Password", text: $password1)
                SecureField("Re-enter Password", text: $password2)
            }
            Section(header: Text("Profile Information")){
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Username", text: $userName)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
//                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
//                                Text("Date of Birth")
//                            }
//                Picker("Gender", selection: $gender) {
//                                        ForEach(Gender.allCases) { gender in
//                                            Text(gender.rawValue.capitalized).tag(gender)
//                                        }
//                            }.pickerStyle(SegmentedPickerStyle())
//                Picker("Class", selection: $gender) {
//                                        ForEach(Standing.allCases) { standing in
//                                            Text(standing.rawValue.capitalized).tag(standing)
//                                        }
//                            }
          
            }
            Button(action: {
                            //add method call
                WHAPI.sharedInstance.auth.request(.post, urlEncoded:["email":emailAddr, "password":password1, "password_confirmation":password2, "username":userName , "first_name":firstName , "last_name":lastName])
                    .onSuccess{ _ in
                            alertTitle = "Success"
                            alertMessage = "Confirm Account using email link"
                            showAlert = true
                        }
                    .onFailure{ error in
                        alertTitle = "Registration Failed"
                        let val : GenericResponse<LoginProfile>? = WHAPI.sharedInstance.parseErrors(error)
                        if(val?.errors != nil){
                            var err: String = ""
                            for (a , b ) in val?.errors ?? [:] {
                                    if(a  == "full_messages"){
                                    for c in b {
                                        err = err + "\n" + c
                                    }
                                }
                            }
                            alertTitle = "Registration Failed"
                            alertMessage = err
                        }else {
                            alertTitle = "Registration Successful"
                            alertMessage = "Use Email link to confirm"
                        }
                        showAlert = true
                    }
                            
                        }, label: { Text("Submit" )})
            .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text($alertTitle.wrappedValue),
                            message: Text($alertMessage.wrappedValue),
                            dismissButton: .default(Text("Close"))
                        )
                }
            }
            .navigationTitle(Text("Register"))
        }
    
}



struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


