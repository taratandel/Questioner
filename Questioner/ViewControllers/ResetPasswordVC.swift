//
//  ResetPasswordVC.swift
//  Questioner
//
//  Created by negar on 97/Farvardin/05 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController, UserDelegate {

    @IBOutlet weak var password1View: UIView!
    @IBOutlet weak var password2View: UIView!
    
    @IBOutlet weak var password1TF: UITextField!
    @IBOutlet weak var password2TF: UITextField!
    @IBOutlet weak var indic: UIActivityIndicatorView!
    @IBOutlet weak var resetBtn: UIButton!

    var userHelper = UserHelper()
    
    override func viewDidLoad() {

        self.hideKeyboardWhenTappedAround()
        
        super.viewDidLoad()
        self.indic.isHidden = true
        self.userHelper.delegate = self
        self.view.addBackground(imageName: "background2", contentMode: .scaleAspectFill)
        
        password1View.layer.cornerRadius = password1View.frame.height / 2;
        password1View.clipsToBounds = true
        
        let password1ViewShadowframe = CGRect(x: password1View.frame.origin.x-5, y: password1View.frame.origin.y+5, width: password1View.frame.width, height: password1View.frame.height)
        self.view.addSubview(ViewHelper.MakeShadowView(frame: password1ViewShadowframe, color: .black, opacity: 0.5, radius: password1View.frame.height / 2))
        self.view.bringSubview(toFront: password1View)
        
        
        password2View.layer.cornerRadius = password2View.frame.height / 2;
        password2View.clipsToBounds = true
        
        let password2ViewShadowframe = CGRect(x: password2View.frame.origin.x-5, y: password2View.frame.origin.y+5, width: password2View.frame.width, height: password2View.frame.height)
        self.view.addSubview(ViewHelper.MakeShadowView(frame: password2ViewShadowframe, color: .black, opacity: 0.5, radius: password2View.frame.height / 2))
        self.view.bringSubview(toFront: password2View)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reset(_ sender: Any) {
        resetBtn.isEnabled = false

        if password1TF.text != nil && password1TF.text?.count == 11 && password2TF != nil {
            self.indic.isHidden = false
            indic.startAnimating()
            userHelper.resetPass(phone: password1TF.text!, password: password2TF.text!)
            
        }else {
            
            ViewHelper.showToastMessage(message: "All fields required to fill correctly")
        }
        
    }
    func successfulOperation() {
        resetBtn.isEnabled = true

        self.indic.isHidden = true
        self.indic.stopAnimating()
        ViewHelper.showToastMessage(message: "Reset successfuly")
        navigationController?.popViewController(animated: true)
    }

    func unsuccessfulOperation(error: String) {
        resetBtn.isEnabled = true
        
        self.indic.isHidden = true

        self.indic.stopAnimating()
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
