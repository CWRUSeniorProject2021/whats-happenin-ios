//
//  RegistrationView.swift
//  WhatsHappenin
//
//  Created by Prithik Karthikeyan on 9/19/21.
//

import SwiftUI
import CoreData

struct RegistrationView : View {
    

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var userName = ""
    @State private var password1 = ""
    @State private var password2 = ""
    @State private var emailAddr = ""
    @State private var gender = ""
    @State private var standing = ""
    @State private var birthDate = Date()
    
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
                TextField("Username", text: $userName)
                SecureField("Password", text: $password1)
                SecureField("Re-enter Password", text: $password2)
                
            }
            Section(header: Text("Profile Information")){
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Email Address", text: $emailAddr)
                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                                Text("Date of Birth")
                            }
                Picker("Gender", selection: $gender) {
                                        ForEach(Gender.allCases) { gender in
                                            Text(gender.rawValue.capitalized).tag(gender)
                                        }
                            }.pickerStyle(SegmentedPickerStyle())

                
            }
        }

            .navigationBarTitle(Text("Register"))
        }
    
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
