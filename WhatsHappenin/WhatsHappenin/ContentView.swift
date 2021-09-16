//
//  ContentView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 9/7/21.
//

import SwiftUI
import CoreData


    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)


struct ContentView : View {
    
    
    var body: some View {
        VStack {
            WelcomeMessage()
            AppIcon()
            UsernameField()
            PasswordField()
            Login()
            SignUp()
        }
        .padding()
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
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

    

struct WelcomeMessage: View {
    var body: some View {
        Text("What's Happenin'")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct UsernameField: View {
    @State var username: String = ""
    var body: some View {
        TextField("Username", text: $username)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 5)
    }
}

struct PasswordField: View {
    @State var password: String = ""
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 10)
    }
}

struct LoginButton: View {
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}


struct Login: View {
    var body: some View {
        Button(action: {print("Button tapped")}) {
            LoginButton()
        }
    }
}

struct AppIcon: View {
    var body: some View {
        Image("WhatsHappeninIcon")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 20)
    }
}

struct SignUp: View {
    var body: some View {
        Text("SIGN UP")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.blue)
            .cornerRadius(15.0)
    }
}
