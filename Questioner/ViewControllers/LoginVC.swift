//
//  LoginVC.swift
//  Questioner
//
//  Created by negar on 97/Farvardin/04 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UserDelegate{
    

    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var userHelper = UserDefaultHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        userHelper.delegate = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.

        self.view.addBackground(imageName: "background1", contentMode: .scaleAspectFit)
        
        usernameView.layer.cornerRadius = usernameView.frame.height / 2;
        usernameView.clipsToBounds = true
        
        let usernameViewShadowframe = CGRect(x: usernameView.frame.origin.x-5, y: usernameView.frame.origin.y+5, width: usernameView.frame.width, height: usernameView.frame.height)
        self.view.addSubview(ViewHelper.MakeShadowView(frame: usernameViewShadowframe, color: .black, opacity: 0.5, radius: usernameView.frame.height / 2))
        self.view.bringSubview(toFront: usernameView)


        passwordView.layer.cornerRadius = passwordView.frame.height / 2;
        passwordView.clipsToBounds = true
        
        let passwordViewShadowframe = CGRect(x: passwordView.frame.origin.x-5, y: passwordView.frame.origin.y+5, width: passwordView.frame.width, height: passwordView.frame.height)
        self.view.addSubview(ViewHelper.MakeShadowView(frame: passwordViewShadowframe, color: .black, opacity: 0.5, radius: passwordView.frame.height / 2))
        self.view.bringSubview(toFront: passwordView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if usernameTF.text != nil && passwordTF.text != nil {
            userHelper.login(userName: usernameTF.text!, password: passwordTF.text!)
        }
        else {
            ViewHelper.showToastMessage(message: "All fields are required")
        }
    }
    func userLoggedIn() {
        ViewHelper.showToastMessage(message: "Logged In Successfully")
        //indicator
        //segue
    }
    func userCouldNotLoggedIn(error: String) {
        ViewHelper.showToastMessage(message: error)
        
    }

}
