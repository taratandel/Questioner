//
//  ChooseCategoryVC.swift
//  Questioner
//
//  Created by negar on 97/Tir/22 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class ChooseCategoryVC: UIViewController {

    @IBOutlet weak var mathBtn: UIButton!
    @IBOutlet weak var scienceBtn: UIButton!
    @IBOutlet weak var engBtn: UIButton!
    @IBOutlet weak var toeflBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground(imageName: "background1", contentMode: .scaleAspectFill)

        mathBtn.setImage(UIImage(named:"typeBtnPressed1"), for: .highlighted)
        scienceBtn.setImage(UIImage(named:"typeBtnPressed2"), for: .highlighted)
        engBtn.setImage(UIImage(named:"typeBtnPressed3"), for: .highlighted)
        toeflBtn.setImage(UIImage(named:"typeBtnPressed4"), for: .highlighted)

        mathBtn.tag = 1
        scienceBtn.tag = 2
        engBtn.tag = 3
        toeflBtn.tag = 4

    }

    override func viewWillAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeLanguage(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }

        let sendQuestionVC = SegueHelper.createViewController(storyboardName: "Main", viewControllerId: "SendQuestionVC") as! SendQuestionVC
        sendQuestionVC.isSearching = false

        switch button.tag {
        case 1:
            sendQuestionVC.type = .math
        case 2:
            sendQuestionVC.type = .science
        case 3:
             sendQuestionVC.type = .english
        case 4:
            sendQuestionVC.type = .toefl
        default:
            break
        }

        SegueHelper.presentViewController(sourceViewController: self, destinationViewController: sendQuestionVC)
    }

}
