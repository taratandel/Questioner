//
//  SendQuestionVC.swift
//  Questioner
//
//  Created by negar on 97/Aban/30 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

enum typeEnum {
    case none
    case science
    case math
    case english
    case toefl

    var toString : String {
        switch self {
        case .science: return "science"
        case .math: return "math"
        case .english: return "english"
        case .toefl: return "toefl"
        case .none: return ""
        }
    }
}

class SendQuestionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MessageDelegate {
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionTF: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var imageBtn: UIButton!

    var type = typeEnum.none

    var isSearching = false

    var messageHelper = MessageHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initViews() {
        indicator.startAnimating()

        if isSearching {
            questionView.isHidden = true
            indicatorView.isHidden = false
        }else{
            questionView.isHidden = false
            indicatorView.isHidden = true
        }

        indicatorView.layer.cornerRadius = 20
        indicatorView.layer.masksToBounds = true
        indicatorView.alpha = 0.7

        questionView.layer.cornerRadius = 20
        questionView.layer.masksToBounds = true

        questionTF.layer.cornerRadius = 10
        questionTF.layer.masksToBounds = true

        switch type {
        case .english:
            self.view.addBackground(imageName: "background3", contentMode: .scaleAspectFit)
            self.questionView.backgroundColor = UIColor("#f1dda499")
            self.setBtnImgs(type: "eng")
            self.indicatorView.backgroundColor = UIColor("#f1dda499")
        case .math:
            self.view.addBackground(imageName: "background4", contentMode: .scaleAspectFit)
            self.questionView.backgroundColor = UIColor("#c2de9c99")
            self.setBtnImgs(type: "math")
            self.indicatorView.backgroundColor = UIColor("#c2de9c99")
        case .science:
            self.view.addBackground(imageName: "background5", contentMode: .scaleAspectFit)
            self.questionView.backgroundColor = UIColor("#c5c9f399")
            self.setBtnImgs(type: "science")
            self.indicatorView.backgroundColor = UIColor("#c5c9f399")
        case .toefl:
            self.view.addBackground(imageName: "background2", contentMode: .scaleAspectFit)
            self.questionView.backgroundColor = UIColor("#a7cdee99")
            self.setBtnImgs(type: "toefl")
            self.indicatorView.backgroundColor = UIColor("#a7cdee99")
        default:
            break
        }
    }

    func setBtnImgs(type : String) {

        self.imageBtn.setImage(UIImage(named: "\(type)BtnImg"), for: .normal)
        self.imageBtn.setImage(UIImage(named: "\(type)BtnImgPressed"), for: .highlighted)

        self.sendBtn.setImage(UIImage(named: "\(type)BtnSend"), for: .normal)
        self.sendBtn.setImage(UIImage(named: "\(type)BtnSendPressed"), for: .highlighted)

    }


    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    @IBAction func imgPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Please choose to upload image or take new one:", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "take photo", style: .default, handler: {action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)

            }else{
                return
            }
        }))

        alert.addAction(UIAlertAction(title: "upload", style: .default, handler: {action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true

                self.present(imagePicker, animated: true, completion: nil)
            }else{
                return
            }
        }))
        self.present(alert, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

    }

    @IBAction func sendQuestion(_ sender: Any) {
        sendBtn.isEnabled = false
        let defaults = UserDefaults()
        if (defaults.object(forKey: "StudentData") != nil){
            let stdData = defaults.object(forKey: "StudentData") as! Student
            if (questionTF.text?.isEmpty)!{
                ViewHelper.showToastMessage(message: "enter the question first")
                sendBtn.isEnabled = true
            }else{
                messageHelper.sendQuestion(studentId: stdData.phone, message: questionTF.text!, type: type.toString)
            }
        }else{
            ViewHelper.showToastMessage(message: "please try to login first!")
            sendBtn.isEnabled = true
        }
    }

    func sendMessageSuccessfully() {
        questionTF.text = ""

        sendBtn.isEnabled = true

        questionView.isHidden = true
        indicatorView.isHidden = false
    }

    func sendMessageUnsuccessfully(error: String) {
        sendBtn.isEnabled = true

        ViewHelper.showToastMessage(message: error)
    }

}
