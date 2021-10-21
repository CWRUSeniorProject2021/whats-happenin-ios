//
//  LoginView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 9/7/21.
//

import SwiftUI
import CoreData


    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)


struct LoginView : View {
    @State var username : String = Environment.testUserUsername
    @State var password : String = Environment.testUserPassword
    @State var successfulLogin : Bool = false

    
    var body: some View {
            NavigationView{
            VStack {
                welcomeMessageView
                appIconView
                taglineMessageView
                usernameFieldView
                passwordFieldView
                loginButtonView
                registerButtonView
            }
            .padding()
            .navigationBarHidden(true)

        }
    }
    
    private var welcomeMessageView : some View {
        Text("What's Happenin'")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
    
    private var usernameFieldView : some View {
        TextField("Username", text: $username)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 5)
    }
    
    private var passwordFieldView : some View {
        SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 10)
    }
    
    private var loginButtonView : some View {
        Button(action: {
                print("Button tapped")
                GlobalKeychain.set(username, forKey: "email")
                GlobalKeychain.set(password, forKey: "password")
                whAPI.login().onSuccess { _ in
                    successfulLogin = true
                }.onFailure { _ in
                    successfulLogin = false
                }
            }) {
                NavigationLink(destination: EventsListView(searchText: ""), isActive: $successfulLogin) { EmptyView() }
                Text("LOGIN")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
    }
    
    private var registerButtonView : some View {
        NavigationLink(destination:RegistrationView()) {
            Text("REGISTER")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.blue)
                .cornerRadius(15.0)
        }
    }
        
    private var appIconView : some View {
        Image("WhatsHappeninIcon")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 20)
    }
    
    private var taglineMessageView : some View {
        Text("Discover events around you!")
            .font(.title2)
            .fontWeight(.thin)
            .padding(.bottom, 20)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
