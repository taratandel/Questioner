//
//  UserHelper.swift
//  Questioner
//
//  Created by Tara Tandel on 1/21/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase

@objc protocol UserDelegate: NSObjectProtocol {
    @objc optional func successfulOperation()
    @objc optional func unsuccessfulOperation(error: String)

}
class UserHelper {
    //let coreDataHelper = CoreDataHelper()
    var delegate: UserDelegate!
    var fcmToken = ""
    var tryCounter = 0

    let defaults = UserDefaults.standard

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.setFCMToken(notification:)),
            name: Notification.Name("FCMToken"), object: nil)
    }

    class func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard

        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }

    func isQuestioning(phone: String) -> (Bool, String){
        let lstParams: [String: AnyObject] = ["phone": phone as AnyObject]
        var isQuestioning : Bool = false
        var questionType = ""
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.IS_QUESTIONING, lstParam: lstParams){
            response, status in
            if status{
                let data = JSON(response["message"])
                isQuestioning = data["isQuestioning"].boolValue
                questionType = data["questionType"].stringValue
            }
        }
        return (isQuestioning,questionType)
    }

    func isChatting(phone: String) -> (Bool, String, String){
        let lstParams: [String: AnyObject] = ["phone": phone as AnyObject]
        var isChatting : Bool = false
        var conversationId : String = ""
        var questionType : String = ""
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.IS_CHATTING, lstParam: lstParams){
            response, status in
            if status{
                let data = JSON(response["message"])
                isChatting = data["isChatting"].boolValue
                conversationId = data["conversationId"].stringValue
                questionType = data["questionType"].stringValue
            }
        }
        return (isChatting, conversationId, questionType)
    }

    func isFreeTrial(phone: String) -> Bool{
        let lstParams: [String: AnyObject] = ["phone": phone as AnyObject]
        var isFreeTrial : Bool = false
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.IS_FREE_TRIAL, lstParam: lstParams){
            response, status in
            if status{
                isFreeTrial = JSON(response["message"]).boolValue
            }
        }
        return isFreeTrial
    }

    @objc func setFCMToken(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let fcm = userInfo["token"] as? String {
            saveFCMToken(token: fcm)
        }
    }

    func saveFCMToken(token: String) {
        var success = true

        defaults.set(token, forKey: "Token")

        if let stdData = defaults.dictionary(forKey: "StudentData") {
            let lstParams: [String: AnyObject] = ["phone": stdData["phone"] as AnyObject, "fcmToken": token as AnyObject]
            AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_TOKEN, lstParam: lstParams) {
                response, status in
                if status {
                    success = true
                } else {
                    success = false
                }
            }
        } else {
            success = false
        }

        if success {
            tryCounter = 0
        } else if tryCounter < 5 {
            tryCounter += 1
            saveFCMToken(token: token)
        } else {
            tryCounter = 0
        }
    }

    func login(phone: String, password: String) {
        let lstParams: [String: AnyObject] = ["phone": phone as AnyObject, "password": password as AnyObject, "fcmToken": Messaging.messaging().fcmToken as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.LOGIN_SOAL, lstParam: lstParams) {
            response, status in
            if status {

                let data = JSON(response["message"])
                let stdData = Student.buildSingle(jsonData: data)
                self.defaults.set(stdData, forKey: "StudentData")

                if self.delegate.responds (to: #selector(UserDelegate.successfulOperation)) {
                    self.delegate!.successfulOperation!()
                }
            } else {
                if self.delegate.responds(to: #selector(UserDelegate.unsuccessfulOperation(error:))) {
                    self.delegate!.unsuccessfulOperation!(error: JSON(response).stringValue)
                }
            }
        }
    }
    func signup(userName: String, password: String, phone: String, email: String) {
        let lstParams: [String: AnyObject] = ["name": userName as AnyObject, "password": password as AnyObject, "phone": phone as AnyObject, "email": email as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SIGNUP_SOAL, lstParam: lstParams) {
            response, status in
            if status {
                //signup handler
                if self.delegate.responds (to: #selector(UserDelegate.successfulOperation)) {
                    self.delegate!.successfulOperation!()
                }
            }
            else {
                if self.delegate.responds(to: #selector(UserDelegate.unsuccessfulOperation(error:))) {
                    self.delegate!.unsuccessfulOperation!(error: JSON(response).stringValue)
                }
            }
        }
    }

    func resetPass(phone: String, password: String) {
        let lstParams: [String: AnyObject] = ["phone": phone as AnyObject, "password": password as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.RESET_PASS, lstParam: lstParams) {
            response, status in
            if status {
                //signup handler
                if self.delegate.responds (to: #selector(UserDelegate.successfulOperation)) {
                    self.delegate!.successfulOperation!()
                }
            }
            else {
                if self.delegate.responds(to: #selector(UserDelegate.unsuccessfulOperation(error:))) {
                    self.delegate!.unsuccessfulOperation!(error: JSON(response).stringValue)
                }
            }
        }
    }


}

