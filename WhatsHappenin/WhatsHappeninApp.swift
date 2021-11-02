//
//  WhatsHappeninApp.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 9/7/21.
//

import SwiftUI

@main
struct WhatsHappeninApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            rootView.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

let rootView = RootView()
