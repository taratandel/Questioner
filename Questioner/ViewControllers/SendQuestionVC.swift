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
    @IBOutlet weak var bottomOfTheQVC: NSLayoutConstraint!
    
    @IBOutlet weak var questionTF: UITextView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var imageBtn: UIButton!

    @IBOutlet weak var backBtn: UIButton!
    
    var type = typeEnum.math

    var isSearching = false

    var messageHelper = MessageHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        self.hideKeyboardWhenTappedAround()
        questionTF.delegate = self
        messageHelper.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        imageBtn.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initViews() {
        self.backBtn.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)

        indicator.startAnimating()

        if isSearching {
            backBtn.isHidden = true
            questionView.isHidden = true
            indicatorView.isHidden = false
        }else{
            backBtn.isHidden = false
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
            self.view.addBackground(imageName: "background3", contentMode: .scaleAspectFill)
            self.questionView.backgroundColor = UIColor("#f1dda499")
            self.setBtnImgs(type: "eng")
            self.indicatorView.backgroundColor = UIColor("#f1dda499")
        case .math:
            self.view.addBackground(imageName: "background4", contentMode: .scaleAspectFill)
            self.questionView.backgroundColor = UIColor("#c2de9c99")
            self.setBtnImgs(type: "math")
            self.indicatorView.backgroundColor = UIColor("#c2de9c99")
        case .science:
            self.view.addBackground(imageName: "background5", contentMode: .scaleAspectFill)
            self.questionView.backgroundColor = UIColor("#c5c9f399")
            self.setBtnImgs(type: "science")
            self.indicatorView.backgroundColor = UIColor("#c5c9f399")
        case .toefl:
            self.view.addBackground(imageName: "background2", contentMode: .scaleAspectFill)
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

        self.backBtn.setImage(UIImage(named: "\(type)BtnBack"), for: .normal)
        self.backBtn.setImage(UIImage(named: "\(type)BtnBackPressed"), for: .highlighted)
    }

    @objc func backBtnPressed(){
        let chooseCategoryVC = SegueHelper.createViewController(storyboardName: "Main", viewControllerId: "ChooseCategoryVC")
        let nv = UINavigationController()
        nv.viewControllers = [chooseCategoryVC]
        present(nv, animated: true, completion: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomOfTheQVC.constant = keyboardHeight        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        bottomOfTheQVC.constant = 71
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
        backBtn.isEnabled = false
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "StudentData") != nil) {
            let decoder = try? JSONDecoder().decode(Student.self, from: defaults.object(forKey: "StudentData") as! Data)
            if let stdPhone = decoder?.phone,
                let stdActive = decoder?.active {
                if stdActive{
                    if (questionTF.text?.isEmpty)!{
                        ViewHelper.showToastMessage(message: "enter the question first")
                        sendBtn.isEnabled = true
                        backBtn.isEnabled = true
                    }else{
                        messageHelper.sendQuestion(studentId: stdPhone, message: questionTF.text!, type: type.toString)
                        questionView.isHidden = true
                        backBtn.isHidden = true
                        indicatorView.isHidden = false
                    }
                }else{
                    ViewHelper.showToastMessage(message: "your account isn't active.")
                }
            }else{
                ViewHelper.showToastMessage(message: "please try to login first!")
                sendBtn.isEnabled = true
                backBtn.isEnabled = true
            }
        }else{
            ViewHelper.showToastMessage(message: "please try to login first!")
            sendBtn.isEnabled = true
            backBtn.isEnabled = true
        }
    }

    func sendMessageSuccessfully() {
        questionTF.text = ""

        sendBtn.isEnabled = true
        backBtn.isEnabled = true

        self.navigationController?.isNavigationBarHidden = true
    }

    func sendMessageUnsuccessfully(error: String) {
        sendBtn.isEnabled = true
        backBtn.isEnabled = true

        ViewHelper.showToastMessage(message: error)
    }

}

extension SendQuestionVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your question here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.resignFirstResponder()
        } else {
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 500
    }
}

