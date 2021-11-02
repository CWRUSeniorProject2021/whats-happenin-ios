//
//  EventRow.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/2/21.
//

import SwiftUI

struct EventRow: View {
    @Binding var event: Event
    
    var body: some View {
        HStack {
            Image(systemName: "house")
            VStack {
                Text(event.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(event.description)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

//#if DEBUG
//struct EventRow_Previews: PreviewProvider {
//    static var previews: some View {
//        EventRow()
//    }
//}
//#endif
