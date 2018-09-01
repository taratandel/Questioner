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

    var type = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground(imageName: "background1", contentMode: .scaleAspectFit)

        mathBtn.setImage(UIImage(named:"typeBtnPressed1"), for: .highlighted)
        scienceBtn.setImage(UIImage(named:"typeBtnPressed2"), for: .highlighted)
        engBtn.setImage(UIImage(named:"typeBtnPressed3"), for: .highlighted)
        toeflBtn.setImage(UIImage(named:"typeBtnPressed4"), for: .highlighted)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.type = 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func mathPressed(_ sender: Any) {
        self.type = 1
        self.performSegue(withIdentifier: "categorySelected", sender: self)
    }
    @IBAction func sciencePressed(_ sender: Any) {
        self.type = 2
        self.performSegue(withIdentifier: "categorySelected", sender: self)
    }
    @IBAction func engPressed(_ sender: Any) {
        self.type = 3
        self.performSegue(withIdentifier: "categorySelected", sender: self)
    }
    @IBAction func toeflPressed(_ sender: Any) {
        self.type = 4
        self.performSegue(withIdentifier: "categorySelected", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "categorySelected"{
            let destination = segue.destination as! SendQuestionVC
            switch type{
            case 1:
                destination.type = .math
            case 2:
                destination.type = .science
            case 3:
                destination.type = .english
            case 4:
                destination.type = .toefl
            default:
                destination.type = .none
            }
        }

    }

}
