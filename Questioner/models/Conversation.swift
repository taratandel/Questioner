//
//  Conversation.swift
//  Questioner
//
//  Created by negar on 97/Azar/13 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SwiftyJSON

class Conversation: NSObject {
    var name = ""
    var date = ""
    var conversationId = ""
    var questionType = ""
    var isEnd = false

    class func buildSingle(jsonData: JSON) -> Conversation {
        let conversation = Conversation()

        if jsonData["teacherName"].exists(){
            conversation.name = jsonData["teacherName"].stringValue
        }
        if jsonData["conversationId"].exists(){
            conversation.conversationId = jsonData["conversationId"].stringValue
        }
        conversation.questionType = jsonData["questionType"].stringValue
        conversation.isEnd = jsonData["isEnd"].boolValue
        let calendar = NSCalendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX'Z'"
        if let date = dateFormatter.date(from: jsonData["timeStamp"].stringValue) {
            if calendar.isDateInToday(date){
                dateFormatter.dateFormat = "HH:mm"
                conversation.date = (dateFormatter.string(from: date)) + " "
            }else{
                dateFormatter.dateFormat = "MM/dd"
                conversation.date = (dateFormatter.string(from: date)) + " "
            }
        }else{
            conversation.date = ""
        }

        return conversation

    }

    class func buildList(jsonData: JSON) -> [Conversation] {
        var conversations = [Conversation]()
        for index in 0..<jsonData.count {
            conversations.append(Conversation.buildSingle(jsonData: jsonData[index]))
        }
        return conversations
    }
}
