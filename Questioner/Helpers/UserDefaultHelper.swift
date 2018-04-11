//
//  UserDefultHelper.swift
//  Answerer
//
//  Created by Tara Tandel on 1/21/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import SwiftyJSON
@objc protocol UserDelegate : NSObjectProtocol{
    @objc optional func userLoggedIn()
    @objc optional func userCouldNotLoggedIn(error : String)
    
}
class UserDefaultHelper {
    var delegate : UserDelegate!
    class func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
    func login(userName: String, password: String){
        var lstParams : [String : AnyObject] = ["phone":userName as AnyObject,"password": password as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.LOGIN_SOAL, lstParam: lstParams){
            response , status in
            if status {
                //login handler
                if self.delegate.responds (to: #selector(UserDelegate.userLoggedIn)){
                    self.delegate!.userLoggedIn!()
                }
            }
            else {
                if self.delegate.responds(to: #selector(UserDelegate.userCouldNotLoggedIn(error:))){
                    self.delegate!.userCouldNotLoggedIn!(error: JSON(response).stringValue)
                }
            }
            
            
        }
    }
    func signup(userName: String, password: String, phone : String, email: String){
        var lstParams : [String : AnyObject] = ["name":userName as AnyObject,"password": password as AnyObject,"phone": phone as AnyObject, "email" : email as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SIGNUP_SOAL, lstParam: lstParams){
            response , status in
            if status {
                //signup handler
                if self.delegate.responds (to: #selector(UserDelegate.userLoggedIn)){
                    self.delegate!.userLoggedIn!()
                }
            }
            else {
                if self.delegate.responds(to: #selector(UserDelegate.userCouldNotLoggedIn(error:))){
                    self.delegate!.userCouldNotLoggedIn!(error: JSON(response).stringValue)
                }
            }
            
            
        }
    }
    func rsetPass(phone : String, password : String){
        var lsParamss : [String : AnyObject] = ["phone" : phone as AnyObject, "password" : password as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.RESET_PASS, lstParam: lsParamss){
            response , status in
            if status {
                //signup handler
                if self.delegate.responds (to: #selector(UserDelegate.userLoggedIn)){
                    self.delegate!.userLoggedIn!()
                }
            }
            else {
                if self.delegate.responds(to: #selector(UserDelegate.userCouldNotLoggedIn(error:))){
                    self.delegate!.userCouldNotLoggedIn!(error: JSON(response).stringValue)
                }
            }
            
            
        }
        
        
    }
}

