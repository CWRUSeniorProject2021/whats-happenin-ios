//
//  ShowProfilePage.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 10/31/21.
//
import SwiftUI

struct ShowProfilePage: View {
    @ObservedObject var controller = ProfilePageController.sharedInstance
    
    @Binding var isLoggedIn: Bool
    @State private var willMoveToNextScreen = false
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                Text("\($controller.myProfile.wrappedValue?.firstName ?? "N/A") \($controller.myProfile.wrappedValue?.lastName ?? "N/A")")
                    .font(.title)
                    .bold()
            }
        }

        Spacer().frame(height: 30)

        VStack(alignment: .center, spacing: 12) {
            HStack {
                Image(systemName: "envelope")
                Text($controller.myProfile.wrappedValue?.email ?? "N/A")
            }

            HStack {
                Image(systemName: "graduationcap")
                Text($controller.myProfile.wrappedValue?.school.name ?? "N/A")
            }

            HStack {
                Image(systemName: "person.text.rectangle")
                Text($controller.myProfile.wrappedValue?.username ?? "N/A")
            }
        }

        Spacer().frame(height: 30)

        NavigationLink(destination: EditProfileInfo()) {
            Text("Edit Information")
                .bold()
                .frame(width: 260, height: 50)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        
        Button {
            print("Button Tapped")
            WHAPI.sharedInstance.logout()
                .onSuccess { _ in
                    isLoggedIn = false
                    //rootView.logout()
                }
        } label : {
            Text("Log Out")
                .bold()
                .frame(width: 260, height: 50)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}

struct ShowProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ShowProfilePage(isLoggedIn: .constant(true))
    }
}
