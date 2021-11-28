//
//  CommentsSectionView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/26/21.
//

import SwiftUI

struct CommentsSectionView: View {
    @Binding var event: Event
    @ObservedObject var newCommentData: NewCommentData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Comments")
                    .font(Font.system(size: 20))
                    .foregroundColor(Color("FontColor"))
                
                Spacer()
                
                Button(action: {
                    self.newCommentData.isCommenting = true
                    self.newCommentData.text = ""
                    self.newCommentData.parentId = nil
                    self.newCommentData.placeholder = nil
                }) {
                    Text("Comment")
                }
            }
            
            let comments = sortAndArrangeComments(event.comments)
            let parentArr = Array(Array(comments.keys).sorted(by: { $0.id > $1.id}).enumerated())
            ForEach(parentArr, id: \.offset) { pID, parent in
                CommentView(comment: .constant(parent), newCommentData: newCommentData)
                    .padding(.top, pID == 0 ? 10 : 20)
                
                if let children = comments[parent] {
                    ForEach(children) { child in
                        CommentView(comment: .constant(child), newCommentData: newCommentData)
                            .padding(.top, 10)
                    }
                }
            }
        }
    }
    
    func sortAndArrangeComments(_ comments: [Comment]) -> [Comment:[Comment]] {
        let parents = comments.filter { comment in
            return comment.parentId == nil
        }
        
        var arrComments = [Comment: [Comment]]()
        parents.forEach { pc in
            var children = comments.filter { comment in
                return comment.parentId == pc.id
            }
            children = children.sorted(by: { $0.id < $1.id})
            arrComments[pc] = children
        }
        return arrComments
    }
}

struct CommentsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsSectionView(event: .constant(Event.samples()[0]), newCommentData: NewCommentData())
    }
}
