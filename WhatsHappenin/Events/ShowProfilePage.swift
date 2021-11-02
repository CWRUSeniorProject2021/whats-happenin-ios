//
//  ShowProfilePage.swift
//  WhatsHappenin
//
//  Created by Eddie Xu on 10/31/21.
//
import SwiftUI

struct ShowProfilePage: View {
    let profilePageCntrl = ProfilePageController()
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                Text("Christian Tingle")
                    .font(.title)
                    .bold()
            }
        }

        Spacer().frame(height: 30)

        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "envelope")
                Text(profilePageCntrl.username)
            }

            HStack {
                Image(systemName: "phone")
                Text("216-943-1302")
            }

            HStack {
                Image(systemName: "network")
                Text("cpt15.com")
            }
        }

        Spacer().frame(height: 30)

        Button {
            print("Button Tapped")
        } label : {
            Text("Updated Profile")
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
        ShowProfilePage()
    }
}

/*
 
 Idea: userAuthData of WHAPI()
 
  Things I need for profile page: Username, Email, Year,
  
  
 */
