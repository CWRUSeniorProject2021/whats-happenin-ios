//
//  Comment.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/26/21.
//

import SwiftUI

struct CommentView: View {
    @Binding var comment: Comment
    
    var body: some View {
        let isReply = comment.parentId != nil
        let indentAmount: CGFloat = isReply ? 25 : 0
        
        VStack(alignment: .leading, spacing: 0) {
            (Text($comment.commenterName.wrappedValue).bold() +
             Text("  \($comment.text.wrappedValue)"))
            
            HStack() {
                Text(getTimeDiff(comment.createdAt))
                    .frame(width: 30, alignment: .leading)
                
                Button(action: createReply) {
                    Text("Reply")
                        
                }
            }
            .foregroundColor(Color("LightFontColor"))
            .padding(.top, 6)
            .font(Font.system(size: 12))
        }
        .padding(.leading, indentAmount)
    }
    
    func getTimeDiff(_ postTime: Date) -> String {
        let interval = Date() - postTime

        var dateString = ""
        if (interval.month > 12) {
            dateString = "\(interval.month / 12)y"
        } else if (interval.hour > 23) {
            dateString = "\(interval.day)d"
        } else if (interval.minute > 59) {
            dateString = "\(interval.hour)h"
        } else if (interval.second > 59) {
            dateString = "\(interval.minute)m"
        } else {
            dateString = "\(interval.second)s"
        }
        
        return dateString
    }
    
    func createReply() {
        
    }
}

struct Comment_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: .constant(Comment(id: 0, text: "Hi there", parentId: nil, createdAt: Date().addingTimeInterval(-100000))))
    }
}

extension Date {
    //https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift
    static func -(recent: Date, previous: Date) -> (month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day!
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month!
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour!
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute!
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second!

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}
