//
//  Message.swift
//  Questioner
//
//  Created by negar on 97/Mordad/15 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class Message: NSObject {

    var isTeacher = false
    var teacherId = ""
    var studentId = ""
    var name = ""

    var message = ""
    var image = ""
    var file = ""
    var timeStamp = ""

    var questionType = 0
    var messageType = 0
    var isEnd = false
    var conversationId = ""


    class func buildSingle(jsonData: JSON) -> Message {
        let BASE_URL = "http://178.63.114.19:2020/media/"
        
        let message = Message()
        //inja bayad badan esme moalem ro begirimo bezarim

        message.isTeacher = jsonData["isTeacher"].boolValue
        message.teacherId = jsonData["teacherId"].stringValue
        message.studentId = jsonData["studentId"].stringValue
        if message.isTeacher{
            message.name = " teacher"
        }else{
            message.name = " me"
        }

        message.message = "  " + jsonData["message"].stringValue
        if jsonData["image"].stringValue.count != 0{
            message.image = BASE_URL + jsonData["image"].stringValue
        }
        if jsonData["file"].stringValue.count != 0{
            message.file = BASE_URL + jsonData["file"].stringValue
        }

        let calendar = NSCalendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX'Z'"
        if let date = dateFormatter.date(from: jsonData["timeStamp"].stringValue) {
            if calendar.isDateInToday(date){
                dateFormatter.dateFormat = "HH:mm"
                message.timeStamp = (dateFormatter.string(from: date)) + " "
            }else{
                dateFormatter.dateFormat = "MM/dd"
                message.timeStamp = (dateFormatter.string(from: date)) + " "
            }
        }else{
            message.timeStamp = ""
        }

        message.questionType = jsonData["questionType"].intValue
        message.messageType = jsonData["messageType"].intValue
        message.isEnd = jsonData["isEnd"].boolValue
        message.conversationId = jsonData["conversationId"].stringValue
        
        return message

    }

    class func buildList(jsonData: JSON) -> [Message] {
        var messages = [Message]()
        for index in 0..<jsonData.count {
            messages.append(Message.buildSingle(jsonData: jsonData[index]))
        }
        return messages
    }
}
