//
//  SendQuestionVC.swift
//  Questioner
//
//  Created by negar on 97/Tir/23 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class SendQuestionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, MessageDelegate, UICollectionViewDataSource{

    enum typeEnum {
        case none
        case science
        case math
        case english
        case toefl
    }

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!

    @IBOutlet weak var questionView: UIView!

    @IBOutlet weak var questionTF: UITextField!
    @IBOutlet weak var attachmentBtn: UIButton!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messagesCollectionView: UICollectionView!

    var type = typeEnum.none

    var timer = Timer()

    var messageHelper = MessageHelper()
    var messages = [Message()]
    var numOfCurrentMessages : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initViews()

        messageHelper.delegate = self

        messagesCollectionView.delegate = self

        self.questionView.layer.cornerRadius = 30
        self.questionView.clipsToBounds = true

        self.questionTF.layer.cornerRadius = 30

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.getMessages()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.getMessages), userInfo: nil, repeats: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initViews() {
        switch type {
        case .english:
            self.view.addBackground(imageName: "background3", contentMode: .scaleAspectFit)
            self.questionView.backgroundColor = UIColor("#f1dda499")
            self.setBtnImgs(type: "eng")
        case .math:
            self.view.addBackground(imageName: "background4", contentMode: .scaleAspectFit)
            self.questionView.backgroundColor = UIColor("#c2de9c99")
            self.setBtnImgs(type: "math")
        case .science:
            self.view.addBackground(imageName: "background5", contentMode: .scaleAspectFit)
            self.questionView.backgroundColor = UIColor("#c5c9f399")
            self.setBtnImgs(type: "science")
        case .toefl:
            self.view.addBackground(imageName: "background2", contentMode: .scaleAspectFit)
            self.questionView.backgroundColor = UIColor("#a7cdee99")
            self.setBtnImgs(type: "toefl")
        default:
            break
        }
    }

    func setBtnImgs(type : String) {
        self.backBtn.setImage(UIImage(named: "\(type)BtnBack"), for: .normal)
        self.backBtn.setImage(UIImage(named: "\(type)BtnBackPressed"), for: .highlighted)

        self.historyBtn.setImage(UIImage(named: "\(type)BtnHistory"), for: .normal)
        self.historyBtn.setImage(UIImage(named: "\(type)BtnHistoryPressed"), for: .highlighted)

        self.attachmentBtn.setImage(UIImage(named: "\(type)BtnAttachment"), for: .normal)
        self.attachmentBtn.setImage(UIImage(named: "\(type)BtnAttachment"), for: .highlighted)

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

    @IBAction func filePressed(_ sender: Any) {

    }

    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func send(_ sender: Any) {

    }

    @objc func getMessages(){
        messageHelper.getMessage(teacherID: "09000000001", studentID: "09000000002")
    }

    func getMessagesSuccessfully(messages: [Message]) {

        if messages.count > numOfCurrentMessages{
            self.messages = messages
//            let indexPaths = Array(numOfCurrentMessages..<messages.count).map { IndexPath(item: $0, section: 0) }
//            messagesCollectionView.insertItems(at: indexPaths)
            messagesCollectionView.reloadData()
            numOfCurrentMessages = messages.count
        }
    }

    func getMessagesUnsuccessfully(error: String) {
        ViewHelper.showToastMessage(message: error)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCVC
        let message = messages[indexPath.row]
        cell.messageLbl.text = message.message
        cell.nameLbl.text = message.name
        cell.timeLbl.text = message.time
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
