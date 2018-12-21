//
//  SendQuestionVC.swift
//  Questioner
//
//  Created by negar on 97/Tir/23 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import FloatRatingView

class ChatVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, MessageDelegate, UICollectionViewDataSource, FloatRatingViewDelegate{

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!

    @IBOutlet weak var questionView: UIView!

    @IBOutlet weak var questionTF: UITextField!
    @IBOutlet weak var attachmentBtn: UIButton!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messagesCollectionView: UICollectionView!

    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var rateBox: UIView!
    @IBOutlet weak var rateConfirmBtn: UIButton!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var rateTitleLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!

    var type = typeEnum.none
    var timer = Timer()
    var isEnd = false

    var messageHelper = MessageHelper()
    var messages = [Message()]
    var numOfCurrentMessages : Int = 0
    var conversationId = ""
    var isRated = true

    var teacherId = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        self.initViews()
        self.initRateView()
        ratingView.isHidden = true

        messageHelper.delegate = self
        floatRatingView.delegate = self

        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self


        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.getMessages()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.getMessages), userInfo: nil, repeats: true)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let contentSize: CGSize? = messagesCollectionView?.collectionViewLayout.collectionViewContentSize
        if (messagesCollectionView?.bounds.size.height.isLess(than: (contentSize?.height)!))! {
            let targetContentOffset = CGPoint(x: 0.0, y: (contentSize?.height)! - (messagesCollectionView?.bounds.size.height)!)
            messagesCollectionView?.contentOffset = targetContentOffset
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initViews() {
        messagesCollectionView.isHidden = true

        switch type {
        case .english:
            self.view.addBackground(imageName: "background3", contentMode: .scaleAspectFill)
            self.questionView.backgroundColor = UIColor("#f1dda499")
            self.setBtnImgs(type: "eng")
        case .math:
            self.view.addBackground(imageName: "background4", contentMode: .scaleAspectFill)
            self.questionView.backgroundColor = UIColor("#c2de9c99")
            self.setBtnImgs(type: "math")
        case .science:
            self.view.addBackground(imageName: "background5", contentMode: .scaleAspectFill)
            self.questionView.backgroundColor = UIColor("#c5c9f399")
            self.setBtnImgs(type: "science")
        case .toefl:
            self.view.addBackground(imageName: "background2", contentMode: .scaleAspectFill)
            self.questionView.backgroundColor = UIColor("#a7cdee99")
            self.setBtnImgs(type: "toefl")
        default:
            break
        }

        self.questionTF.layer.cornerRadius = 30
        self.questionView.layer.cornerRadius = 30
        self.questionView.clipsToBounds = true

        if isEnd{
            sendBtn.isEnabled = false
        }else{
            sendBtn.isEnabled = true
        }
    }

    func initRateView() {
        rateBox.layer.cornerRadius = 30
        rateBox.layer.masksToBounds = true

        self.rateConfirmBtn.setImage(#imageLiteral(resourceName: "confirmBtn"), for: .normal)
        self.rateConfirmBtn.setImage(#imageLiteral(resourceName: "confirmBtnPressed"), for: .highlighted)

        self.floatRatingView.emptyImage = #imageLiteral(resourceName: "emptyStar")
        self.floatRatingView.fullImage = #imageLiteral(resourceName: "fullStar")
        self.floatRatingView.contentMode = .scaleAspectFill
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 0
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
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
            if self.questionView.frame.origin.y == 0{
                self.questionView.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.questionView.frame.origin.y != 0{
                self.questionView.frame.origin.y += keyboardSize.height
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
        sendBtn.isEnabled = false
        imageBtn.isEnabled = false
        attachmentBtn.isEnabled = false

        if (questionTF.text?.isEmpty)!{
            ViewHelper.showToastMessage(message: "There is nothing to send")
        }else{
            var typeString = String()
            switch type {
            case .english:
                typeString = "english"
            case .math:
                typeString = "math"
            case .science:
                typeString = "science"
            case .toefl:
                typeString = "toefl"
            default:
                break
            }
            messageHelper.sendMessage(conversationId: self.conversationId, message: questionTF.text!, type: typeString)
        }
    }

    func sendMessageSuccessfully() {
        questionTF.text = ""

        sendBtn.isEnabled = true
        imageBtn.isEnabled = true
        attachmentBtn.isEnabled = true

        getMessages()
    }

    func sendMessageUnsuccessfully(error: String) {
        sendBtn.isEnabled = true
        imageBtn.isEnabled = true
        attachmentBtn.isEnabled = true

        ViewHelper.showToastMessage(message: error)
    }

    @objc func getMessages(){
        messageHelper.getMessage(conversationId: self.conversationId)
    }

    func getMessagesSuccessfully(messages: [Message]) {

        if messages.count > numOfCurrentMessages{
            self.messagesCollectionView.isHidden = false
            self.messages = messages

            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToItem(at: IndexPath(item: messages.count-1, section: 0), at: .top, animated: true)
            numOfCurrentMessages = messages.count

            if (messages.last?.isEnd)! && !isRated{
                self.teacherId = (messages.last?.teacherId)!
                self.ratingView.isHidden = false
            }
        }
    }

    func getMessagesUnsuccessfully(error: String) {
        ViewHelper.showToastMessage(message: error)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCVC
        let message = messages[indexPath.row]
        cell.messageLbl.text = message.message
        cell.nameLbl.text = message.name
        cell.timeLbl.text = message.time

        switch type {
        case .english:
            cell.nameLbl.textColor = UIColor("#66320F99")
            cell.timeLbl.textColor = UIColor("#AF371699")
        case .math:
            cell.nameLbl.textColor = UIColor("#455D2099")
            cell.timeLbl.textColor = UIColor("#95C45799")
        case .science:
            cell.nameLbl.textColor = UIColor("#47184C99")
            cell.timeLbl.textColor = UIColor("#66408A99")
        case .toefl:
            cell.nameLbl.textColor = UIColor("#1C3E5C99")
            cell.timeLbl.textColor = UIColor("#175D9999")
        default:
            break
        }
        cell.layer.opacity = 1
        return cell
    }

    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        rateLbl.text = "\(floatRatingView.rating)"
    }

    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Float) {
        rateLbl.text = "\(floatRatingView.rating)"
    }

    @IBAction func sendRate(_ sender: Any) {
        rateConfirmBtn.isEnabled = false
        messageHelper.sendRate(teacherId: self.teacherId, rate: floatRatingView.rating, conversationId: self.conversationId)
    }

    func sendRateSuccessfully() {
        ViewHelper.showToastMessage(message: "Thanks!")

        rateConfirmBtn.isEnabled = true
        self.ratingView.isHidden = true
        let historyVC = SegueHelper.createViewController(storyboardName: "Main", viewControllerId: "HistoryVC") as! HistoryVC
        SegueHelper.presentViewController(sourceViewController: self, destinationViewController: historyVC)
    }

    func sendRateUnsuccessfully(error: String) {
        rateConfirmBtn.isEnabled = true
        ViewHelper.showToastMessage(message: error)
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
