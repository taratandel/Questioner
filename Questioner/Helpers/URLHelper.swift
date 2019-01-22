//
//  urls.swift
//  Questioner
//
//  Created by negar on 1/20/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation

class URLHelper : NSObject {
    static let LOGIN_SOAL = "soal/login/"
    static let SIGNUP_SOAL = "soal/register/"
    static let RESET_PASS = "soal/resetpassword/"

    static let SEND_MSG = "chat/send/"
    static let GET_MSG = "chat/get/"
    static let SEND_IMG = "chat/sendimage/"
    //static let SEND_FILE = "chat/sendfile/"
    static let SEND_VOICE = "chat/sendfile/"
    static let GET_CONVS = "chat/getconversations/"
    static let SEND_RATE = "chat/rate/"


    static let SEND_Q = "chat/sendquestion/"

    static let SEND_TOKEN = "soal/setfcmtoken/"
    static let IS_CHATTING = "chat/ischatting/"
    static let IS_QUESTIONING = "chat/isquestioning/"
    static let IS_FREE_TRIAL = "soal/isfreetrial/"
}
