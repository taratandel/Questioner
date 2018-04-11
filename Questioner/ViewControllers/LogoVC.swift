//
//  LogoVC.swift
//  Questioner
//
//  Created by negar on 97/Farvardin/09 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class LogoVC: UIViewController {

    @IBOutlet weak var logoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseOut, animations: {
            self.logoView.layer.opacity = 0
        }, completion: nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        sleep(3)
        self.performSegue(withIdentifier: "AfterLogoSegue", sender: self)
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
