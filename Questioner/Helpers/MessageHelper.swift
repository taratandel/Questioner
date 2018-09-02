//
//  MessageHelper.swift
//  Questioner
//
//  Created by negar on 97/Mordad/15 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SwiftyJSON

@objc protocol MessageDelegate: NSObjectProtocol {
    @objc optional func sendMessageSuccessfully()
    @objc optional func sendMessageUnsuccessfully(error: String)

    @objc optional func getMessagesSuccessfully(messages: [Message])
    @objc optional func getMessagesUnsuccessfully(error: String)
}
class MessageHelper {
    var delegate: MessageDelegate!

    func sendMessage(teacherID: String, studentID: String, message: String, type: String) {
        let lstParams: [String: AnyObject] = ["teacherId": teacherID as AnyObject, "studentId": studentID as AnyObject, "message": message as AnyObject, "isTeacher": false as AnyObject, "questionType": type as AnyObject]

        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_MSG, lstParam: lstParams, onCompletion: {
            response, status in
            if status {
                if self.delegate.responds (to: #selector(MessageDelegate.sendMessageSuccessfully)){
                    self.delegate!.sendMessageSuccessfully!()
                }
            } else {
                if self.delegate.responds (to: #selector(MessageDelegate.sendMessageUnsuccessfully(error:))){
                    self.delegate!.sendMessageUnsuccessfully!(error: JSON(response).stringValue)
                }
            }
        })
    }

    func sendImgMessage(teacherID: String, studentID: String, message: String, type: String, image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1)
        let lstParams: [String: AnyObject] = ["teacherId": teacherID as AnyObject, "studentId": studentID as AnyObject, "message": message as AnyObject, "isTeacher": false as AnyObject, "questionType": type as AnyObject, "image": imageData as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_IMG, lstParam: lstParams, onCompletion: {
            response, status in
            if status {
                if self.delegate.responds (to: #selector(MessageDelegate.sendMessageSuccessfully)){
                    self.delegate!.sendMessageSuccessfully!()
                }
            } else {
                if self.delegate.responds (to: #selector(MessageDelegate.sendMessageUnsuccessfully(error:))){
                    self.delegate!.sendMessageUnsuccessfully!(error: JSON(response).stringValue)
                }
            }
        })
    }

    func sendFileMessage(teacherID: String, studentID: String, message: String, type: String) {
        let lstParams: [String: AnyObject] = ["teacherId": teacherID as AnyObject, "studentId": studentID as AnyObject, "message": message as AnyObject, "isTeacher": false as AnyObject, "questionType": type as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_FILE, lstParam: lstParams, onCompletion: {
            response, status in
            if status {
                if self.delegate.responds (to: #selector(MessageDelegate.sendMessageSuccessfully)){
                    self.delegate!.sendMessageSuccessfully!()
                }
            } else {
                if self.delegate.responds (to: #selector(MessageDelegate.sendMessageUnsuccessfully(error:))){
                    self.delegate!.sendMessageUnsuccessfully!(error: JSON(response).stringValue)
                }
            }
        })
    }

    func getMessage(teacherID: String, studentID: String) {
        let lstParams: [String: AnyObject] = ["teacherId": teacherID as AnyObject, "studentId": studentID as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.GET_MSG, lstParam: lstParams, onCompletion: {
            response, status in
            if status {
                var messages = [Message]()
                let msg = JSON(response["messages"])
                messages = Message.buildList(jsonData: msg)

                if self.delegate.responds (to: #selector(MessageDelegate.getMessagesSuccessfully)){
                    self.delegate!.getMessagesSuccessfully!(messages: messages)
                }
            } else {
                if self.delegate.responds (to: #selector(MessageDelegate.getMessagesUnsuccessfully(error:))){
                    self.delegate!.getMessagesUnsuccessfully!(error: JSON(response).stringValue)
                }
            }
        })
    }


    
}
