//
//  NewCommentData.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/28/21.
//

import Foundation

class NewCommentData: ObservableObject {
    @Published var isCommenting: Bool = false
    @Published var text: String = ""
    @Published var parentId: Int?
    @Published var placeholder: String?
    
    func reset() {
        self.isCommenting = false
        self.text = ""
        self.parentId = nil
        self.placeholder = nil
    }
}
