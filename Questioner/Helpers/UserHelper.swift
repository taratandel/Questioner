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
    @objc optional func successfulTrial(isFreeTrial: Bool)
    @objc optional func successfulStatusUpdate(isQuestioning: Bool, isChatting: Bool, questionType: String, conversationId: String)
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

    func isChattingOrQuestioning(phone: String){
        let lstParams: [String: AnyObject] = ["phone": phone as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.IS_CHATTING, lstParam: lstParams){
            response, status in
            if status{
                let data = JSON(response["message"])
                let isChatting = data["isChatting"].boolValue
                let conversationId = data["conversationId"].stringValue
                let questionType = data["questionType"].stringValue
                if isChatting{
                    if self.delegate.responds (to: #selector(UserDelegate.successfulStatusUpdate)) {
                        self.delegate!.successfulStatusUpdate!(isQuestioning: false, isChatting: true, questionType: questionType, conversationId: conversationId)
                    }
                }else{
                    AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.IS_QUESTIONING, lstParam: lstParams){
                        response, status in
                        if status{
                            let data = JSON(response["message"])
                            let isQuestioning = data["isQuestioning"].boolValue
                            let questionType = data["questionType"].stringValue
                            if isQuestioning{
                                if self.delegate.responds (to: #selector(UserDelegate.successfulStatusUpdate)) {
                                    self.delegate!.successfulStatusUpdate!(isQuestioning: true, isChatting: false, questionType: questionType, conversationId: "")
                                }
                            }else{
                                if self.delegate.responds (to: #selector(UserDelegate.successfulStatusUpdate)) {
                                    self.delegate!.successfulStatusUpdate!(isQuestioning: false, isChatting: false, questionType: "", conversationId: "")
                                }
                            }
                        }else{
                            if self.delegate.responds(to: #selector(UserDelegate.unsuccessfulOperation(error:))) {
                                self.delegate!.unsuccessfulOperation!(error: JSON(response).stringValue)
                            }
                        }
                    }
                }
            } else {
                if self.delegate.responds(to: #selector(UserDelegate.unsuccessfulOperation(error:))) {
                    self.delegate!.unsuccessfulOperation!(error: JSON(response).stringValue)
                }

            }
        }
    }

    func isFreeTrial(phone: String){
        let lstParams: [String: AnyObject] = ["phone": phone as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.IS_FREE_TRIAL, lstParam: lstParams){
            response, status in
            if status{
                let isFreeTrial = JSON(response["message"]).boolValue
                if self.delegate.responds (to: #selector(UserDelegate.successfulTrial)) {
                    self.delegate!.successfulTrial!(isFreeTrial: isFreeTrial)
                }
            } else {
                if self.delegate.responds(to: #selector(UserDelegate.unsuccessfulOperation(error:))) {
                    self.delegate!.unsuccessfulOperation!(error: JSON(response).stringValue)
                }
            }
        }
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

        if defaults.object(forKey: "StudentData") != nil {
            let decoder = try? JSONDecoder().decode(Student.self, from: defaults.object(forKey: "StudentData") as! Data)
            if let stdPhone = decoder?.phone {
                let lstParams: [String: AnyObject] = ["phone": stdPhone as AnyObject, "fcmToken": token as AnyObject]
                AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_TOKEN, lstParam: lstParams) {
                    response, status in
                    if status {
                        success = true
                    } else {
                        success = false
                    }
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
                let encoder = JSONEncoder()
                if let studentData = try? encoder.encode(stdData) {
                    UserDefaults.standard.set(studentData, forKey: "StudentData")
                }

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

