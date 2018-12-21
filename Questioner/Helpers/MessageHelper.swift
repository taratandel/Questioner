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

    @objc optional func getConversationsSuccessfully(conversations: [Conversation])
    @objc optional func getConversationsUnsuccessfully(error: String)

    @objc optional func sendRateSuccessfully()
    @objc optional func sendRateUnsuccessfully(error: String)

}

protocol sendChatDelegate: NSObjectProtocol {
    func sendChatStatus(isSucceded: Bool)
}

class MessageHelper {
    var delegate: MessageDelegate!
    weak var sendDelegate: sendChatDelegate?
    var conversationId = ""

    func sendMessage(conversationId: String, message: String, type: String) {
        let lstParams: [String: AnyObject] = ["conversationId": conversationId as AnyObject, "message": message as AnyObject, "isTeacher": false as AnyObject, "questionType": type as AnyObject]

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

    func sendRate(teacherId: String, rate: Float, conversationId: String) {
        let lstParams: [String: AnyObject] = ["teacherId": teacherId as AnyObject, "rate": rate as AnyObject, "conversationId": conversationId as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_RATE, lstParam: lstParams, onCompletion: {
            response, status in
            if status {
                if self.delegate.responds (to: #selector(MessageDelegate.sendRateSuccessfully)){
                    self.delegate!.sendRateSuccessfully!()
                }
            } else {
                if self.delegate.responds (to: #selector(MessageDelegate.sendRateUnsuccessfully(error:))){
                    self.delegate!.sendRateUnsuccessfully!(error: JSON(response).stringValue)
                }
            }
        })
    }
    func sendImgMessage(conversationId: String, message: String, type: String, image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 1)
        let lstParams: [String: AnyObject] = ["conversationId": conversationId as AnyObject, "message": message as AnyObject, "isTeacher": false as AnyObject, "questionType": type as AnyObject, "image": imageData as AnyObject]

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

//    func sendFileMessage(conversationId: String, message: String, type: String) {
//        let lstParams: [String: AnyObject] = ["conversationId": conversationId as AnyObject, "message": message as AnyObject, "isTeacher": false as AnyObject, "questionType": type as AnyObject]
//        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_FILE, lstParam: lstParams, onCompletion: {
//            response, status in
//            if status {
//                if self.delegate.responds (to: #selector(MessageDelegate.sendMessageSuccessfully)){
//                    self.delegate!.sendMessageSuccessfully!()
//                }
//            } else {
//                if self.delegate.responds (to: #selector(MessageDelegate.sendMessageUnsuccessfully(error:))){
//                    self.delegate!.sendMessageUnsuccessfully!(error: JSON(response).stringValue)
//                }
//            }
//        })
//    }

    func getMessage(conversationId: String) {
        let lstParams: [String: AnyObject] = ["conversationId": conversationId as AnyObject]
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

    func getConversation(studentId: String) {
        let lstParams: [String: AnyObject] = ["studentId": studentId as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.GET_CONVS, lstParam: lstParams, onCompletion: {
            response, status in
            if status {
                var conversations = [Conversation]()
                let msg = JSON(response["conversations"])
                conversations = Conversation.buildList(jsonData: msg)

                if self.delegate.responds (to: #selector(MessageDelegate.getConversationsSuccessfully)){
                    self.delegate!.getConversationsSuccessfully!(conversations: conversations)
                }
            } else {
                if self.delegate.responds (to: #selector(MessageDelegate.getConversationsUnsuccessfully(error:))){
                    self.delegate!.getConversationsUnsuccessfully!(error: JSON(response).stringValue)
                }
            }
        })
    }

    func sendQuestion(studentId: String, message: String, type: String) {
        let lstParams: [String: AnyObject] = ["studentId": studentId as AnyObject, "message": message as AnyObject, "isTeacher": false as AnyObject, "questionType": type as AnyObject]

        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_Q, lstParam: lstParams, onCompletion: {
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

    func sendChat(message: String?, filePath: URL?, type: Int, images: UIImage?, typeString: String) {
        var url = ""
        switch type {
        case 2:
            url = URLHelper.SEND_VOICE
            let lstParams: [String: AnyObject] = ["conversationId": conversationId as AnyObject, "isTeacher": true as AnyObject, "message": "" as AnyObject,  "questionType": type as AnyObject]
            AlamofireReq.sharedApi.sendPostMPReq(urlString: url, lstParam: lstParams, image: nil, filePath: filePath, onCompletion: {
                response, status in
                if status {
                    self.sendDelegate?.sendChatStatus(isSucceded: true)
                } else {
                    self.sendDelegate?.sendChatStatus(isSucceded: false)
                }
            })

        case 1:
            url = URLHelper.SEND_IMG
            let lstParams: [String: AnyObject] = ["conversationId": conversationId as AnyObject, "isTeacher": true as AnyObject, "message": "" as AnyObject, "questionType": type as AnyObject]
            AlamofireReq.sharedApi.sendPostMPReq(urlString: url, lstParam: lstParams, image: images, filePath: nil, onCompletion: {
                response, status in
                if status {
                    self.sendDelegate?.sendChatStatus(isSucceded: true)
                } else {
                    self.sendDelegate?.sendChatStatus(isSucceded: false)
                }
            })
        default:
            url = URLHelper.SEND_MSG
            let lstParams: [String: AnyObject] = ["conversationId": conversationId as AnyObject, "isTeacher": true as AnyObject, "message": message
                as AnyObject, "questionType": type as AnyObject]
            AlamofireReq.sharedApi.sendPostReq(urlString: url, lstParam: lstParams) {

                response, status in
                if status {
                    self.sendDelegate?.sendChatStatus(isSucceded: true)
                }
                else {
                    self.sendDelegate?.sendChatStatus(isSucceded: false)
                }
            }

        }
    }

}
