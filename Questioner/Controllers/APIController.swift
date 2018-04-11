//
//  APIController.swift
//  Questioner
//
//  Created by Tara Tandel on 1/20/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class AlamofireReq : NSObject{
    let BASE_URL = "http://176.31.42.117:3030/"
    static let sharedApi:AlamofireReq = {
        let instance = AlamofireReq()
        
        return instance
    }()
    func sendPostReq(urlString: String, lstParam: [String:AnyObject],onCompletion:@escaping(JSON,Bool)-> Void){
        let url = BASE_URL + urlString
        _ = Alamofire.request(url, method: .post, parameters: lstParam, encoding: JSONEncoding.default, headers: [:]).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.checkStatus(json: json, onCompletion: onCompletion)
            case .failure(let error):
                let status = ["error" : "\(error)"]
                let json = JSON(status)
                onCompletion(json, false)
                

        }
    }
           
    }

//    func sendMultipartRequest(urlString:String,lstParams:[String:Data],image:UIImage,onCompletion:@escaping(JSON,Bool)-> Void) {
//        let multipartParams = MultipartFormData()
//        for (key,value) in lstParams {
//            multipartParams.append(value, withName: key)
//        }
//        let url = BASE_URL + urlString
//
//        Alamofire.upload(multipartFormData:{ multipartFormData in
//            multipartFormData.append(UIImageJPEGRepresentation(image, 0.9)!, withName: "profile", fileName: "iOS\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
//            for (key,value) in lstParams {
//                //                multipartFormData.append(value, withName: key, mimeType: "application/octet-stream")
//                multipartFormData.append(value, withName: key, mimeType: "application/json")
//            }
//            print(multipartFormData)
//        },
//                         usingThreshold:UInt64.init(),
//                         to:url,
//                         method:.post,
//                         encodingCompletion: { encodingResult in
//                            switch encodingResult {
//                            case .success(let upload, _, _):
//                                upload.responseJSON { response in
//                                    if let value = response.value {
//                                        let json = JSON(value)
//                                        self.checkStatus(json: json, onCompletion: onCompletion)
//                                    }
//                                }
//                            case .failure(let encodingError):
//                                print(encodingError)
//                            }
//        })
//    }
//
    func checkStatus(json:JSON,onCompletion:(JSON,Bool) -> Void) {
        let status = AppTools.convertStringToBool(data: json["status"].stringValue)
        if status{
            onCompletion(json["message"],status)
        }else {
            onCompletion(json["error"],status)
        }


}
}
