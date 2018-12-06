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


class AlamofireReq: NSObject {
    let BASE_URL = "http://188.40.189.4:3030/"

    static let sharedApi: AlamofireReq = {
        let instance = AlamofireReq()

        return instance
    }()

    func sendPostReq(urlString: String, lstParam: [String: AnyObject], onCompletion: @escaping(JSON, Bool) -> Void) {
        let url = BASE_URL + urlString
        _ = Alamofire.request(url, method: .post, parameters: lstParam, encoding: JSONEncoding.default, headers: [:]).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.checkStatus(json: json, onCompletion: onCompletion)
            case .failure(let error):
                let status = ["error": "\(error)"]
                let json = JSON(status)
                onCompletion(json, false)
            }
        }
    }

    func sendPostMPReq(urlString: String, lstParam: [String: AnyObject], image: UIImage, onCompletion: @escaping(JSON, Bool) -> Void) {
        let url = BASE_URL + urlString
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image, 0.8) {
                multipartFormData.append(imageData, withName: "image", fileName: "photo.jpg", mimeType: "jpg/png")
            }
            for (key, value) in lstParam {
                if value is String || value is Int {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
        }, to: url, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            self.checkStatus(json: json, onCompletion: onCompletion)
                        case .failure(let error):
                            let status = ["error": "\(error)"]
                            let json = JSON(status)
                            onCompletion(json, false)
                        }
                    }
                case .failure(let encodingError):
                    print("encoding Error : \(encodingError)")
                }
            })
    }

    func checkStatus(json: JSON, onCompletion: (JSON, Bool) -> Void) {
        let status = AppTools.convertStringToBool(data: json["status"].stringValue)
        if status {
            onCompletion(json, status)
        } else {
            onCompletion(json["error"], status)
        }
    }
}
