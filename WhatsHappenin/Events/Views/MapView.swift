//
//  MapView.swift
//  WhatsHappenin
//
//  Created by Eric Chang on 10/30/21.
//

import SwiftUI

struct MapView: View {
   
    var body: some View {
        VStack {
            ShowMap()
                .edgesIgnoringSafeArea(.all)
            Spacer()
            Buttons()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
