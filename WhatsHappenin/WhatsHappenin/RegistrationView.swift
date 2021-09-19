//
//  RegistrationView.swift
//  WhatsHappenin
//
//  Created by Prithik Karthikeyan on 9/19/21.
//

import SwiftUI
import CoreData

struct RegistrationView : View {
    
    
    var body: some View {
            VStack {
                Text("Hello, World")
            }
            .padding()
            .navigationBarTitle(Text("Register"))
        }
    
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
