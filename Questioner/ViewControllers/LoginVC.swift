//
//  LoginVC.swift
//  Questioner
//
//  Created by negar on 97/Farvardin/04 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UserDelegate {

    let defaults = UserDefaults.standard

    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var indic: UIActivityIndicatorView!

    @IBOutlet weak var loginBtn: UIButton!

    var userHelper = UserHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.indic.isHidden = true
        userHelper.delegate = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.

        self.view.addBackground(imageName: "background1", contentMode: .scaleAspectFill)

        usernameView.layer.cornerRadius = usernameView.frame.height / 2;
        usernameView.clipsToBounds = true

        let usernameViewShadowframe = CGRect(x: usernameView.frame.origin.x - 5, y: usernameView.frame.origin.y + 5, width: usernameView.frame.width, height: usernameView.frame.height)
        self.view.addSubview(ViewHelper.MakeShadowView(frame: usernameViewShadowframe, color: .black, opacity: 0.5, radius: usernameView.frame.height / 2))
        self.view.bringSubview(toFront: usernameView)


        passwordView.layer.cornerRadius = passwordView.frame.height / 2;
        passwordView.clipsToBounds = true

        let passwordViewShadowframe = CGRect(x: passwordView.frame.origin.x - 5, y: passwordView.frame.origin.y + 5, width: passwordView.frame.width, height: passwordView.frame.height)
        self.view.addSubview(ViewHelper.MakeShadowView(frame: passwordViewShadowframe, color: .black, opacity: 0.5, radius: passwordView.frame.height / 2))
        self.view.bringSubview(toFront: passwordView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: Any) {
        loginBtn.isEnabled = false

        if usernameTF.text != nil && passwordTF.text != nil {
            self.indic.isHidden = false
            self.indic.startAnimating()
            userHelper.login(phone: usernameTF.text!, password: passwordTF.text!)
        } else {
            ViewHelper.showToastMessage(message: "All fields are required")
        }
    }
    func successfulOperation() {
        loginBtn.isEnabled = true

        self.indic.isHidden = true
        self.indic.stopAnimating()

        userHelper.isChattingOrQuestioning(phone: usernameTF.text!)
    }

    func successfulStatusUpdate(isQuestioning: Bool, isChatting: Bool, questionType: String, conversationId: String) {
        if isChatting {
            let chatVC = SegueHelper.createViewController(storyboardName: "Main", viewControllerId: "ChatVC") as! ChatVC
            chatVC.conversationId = conversationId
            switch questionType {
            case "science":
                chatVC.type = .science
            case "math":
                chatVC.type = .math
            case "english":
                chatVC.type = .english
            case "toefl":
                chatVC.type = .toefl
            default:
                break
            }
            SegueHelper.presentViewController(sourceViewController: self, destinationViewController: chatVC)
        } else if isQuestioning {
            let sendQVC = SegueHelper.createViewController(storyboardName: "Main", viewControllerId: "SendQuestionVC") as! SendQuestionVC
            switch questionType {
            case "science":
                sendQVC.type = .science
            case "math":
                sendQVC.type = .math
            case "english":
                sendQVC.type = .english
            case "toefl":
                sendQVC.type = .toefl
            default:
                break
            }
            sendQVC.isSearching = true
            SegueHelper.presentViewController(sourceViewController: self, destinationViewController: sendQVC)
        } else{
            let chooseCategoryVC = SegueHelper.createViewController(storyboardName: "Main", viewControllerId: "ChooseCategoryVC")
            SegueHelper.presentViewController(sourceViewController: self, destinationViewController: chooseCategoryVC)
        }
    }
    func unsuccessfulOperation(error: String) {
        loginBtn.isEnabled = true

        self.indic.isHidden = true
        self.indic.stopAnimating()
        ViewHelper.showToastMessage(message: error)
    }


}
