//
//  RootView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/1/21.
//

import SwiftUI

struct RootView: View {
    @State var isLoggedIn : Bool = GlobalKeychain.get("email") ?? "" != "" && GlobalKeychain.get("password") ?? "" != ""
    
    var body: some View {
        if (isLoggedIn) {
            RootTabbedView(isLoggedIn: $isLoggedIn)
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
