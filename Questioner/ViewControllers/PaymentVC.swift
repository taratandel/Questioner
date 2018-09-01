//
//  PaymentVC.swift
//  Questioner
//
//  Created by negar on 97/Tir/23 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {

    @IBOutlet weak var freeTrialBtn: UIButton!
    @IBOutlet weak var oneOneBtn: UIButton!
    @IBOutlet weak var oneAllBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        oneOneBtn.isEnabled = false
        oneAllBtn.isEnabled = false
        self.view.addBackground(imageName: "background1", contentMode: .scaleAspectFit)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
