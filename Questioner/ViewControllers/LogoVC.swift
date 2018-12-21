//
//  LogoVC.swift
//  Questioner
//
//  Created by negar on 97/Farvardin/09 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class LogoVC: UIViewController , UserDelegate{
    let defaults = UserDefaults.standard
    let userHelper = UserHelper()
    var repeatTime = 0

    @IBOutlet weak var logoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userHelper.delegate = self
        repeatTime = 0

        // Do any additional setup after loading the view.

    }

    override func viewWillAppear(_ animated: Bool) {

        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseOut, animations: {
            self.logoView.layer.opacity = 0
        }, completion: nil)

    }

    override func viewDidAppear(_ animated: Bool) {

        sleep(3)
        flowDetector()
    }

    func flowDetector() {
        if (defaults.object(forKey: "StudentData") != nil) {
            let decoder = try? JSONDecoder().decode(Student.self, from: defaults.object(forKey: "StudentData") as! Data)
            if let stdPhone = decoder?.phone,
                let stdActive = decoder?.active {
                if stdActive {
                    userHelper.isChattingOrQuestioning(phone: stdPhone)
                } else {
                    ViewHelper.showToastMessage(message: "your account isn't active.")
                    self.performSegue(withIdentifier: "AfterLogoSegue", sender: self)
                }
            } else {
                self.performSegue(withIdentifier: "AfterLogoSegue", sender: self)
            }
        } else {
            self.performSegue(withIdentifier: "AfterLogoSegue", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func successfulStatusUpdate(isQuestioning: Bool, isChatting: Bool, questionType: String, conversationId: String) {
        repeatTime = 0
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
        }else{
            self.performSegue(withIdentifier: "AfterLogoSegue", sender: self)
        }
    }
    func unsuccessfulOperation(error: String) {
        ViewHelper.showToastMessage(message: error)
        repeatTime += 1
        if repeatTime < 6{
            flowDetector()
        }
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
