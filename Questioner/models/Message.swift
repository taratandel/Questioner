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
    var name = ""
    var message = ""
    var time = ""
    var isTeacher = false
    var image = ""
    var file = ""

    class func buildSingle(jsonData: JSON) -> Message {
        let message = Message()
        //inja bayad badan esme moalem ro begirimo bezarim

        if jsonData["isTeacher"].boolValue{
            message.name = " teacher"
        }else{
            message.name = " me"
        }
        message.message = "  " + jsonData["message"].stringValue

        let calendar = NSCalendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX'Z'"
        if let date = dateFormatter.date(from: jsonData["timeStamp"].stringValue) {
            if calendar.isDateInToday(date){
                dateFormatter.dateFormat = "HH:mm"
                message.time = (dateFormatter.string(from: date)) + " "
            }else{
                dateFormatter.dateFormat = "MM/dd"
                message.time = (dateFormatter.string(from: date)) + " "
            }
        }else{
            message.time = ""
        }
        message.isTeacher = jsonData["isTeacher"].boolValue
        if jsonData["file"].exists(){
            message.file = jsonData["file"].stringValue
        }
        if jsonData["image"].exists(){
            message.image = jsonData["image"].stringValue
        }
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
