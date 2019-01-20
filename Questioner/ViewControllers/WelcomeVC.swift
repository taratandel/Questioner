//
//  WelcomeVC.swift
//  Questioner
//
//  Created by negar on 97/Farvardin/06 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class WelcomeVC: UIViewController {

    @IBOutlet weak var introScrollView: UIScrollView!
    
    let introInfo1 = ["title": "NEED HELP STUYING?",
                      "image": "introImg1",
                      "description": "Need guidance while studying? Not sure if you can come up with the answers all by yourself while doing your homework? Don’t worry! We’re here to help you study easier, faster and better.",
                      "background": "background2",
                      "btnImg": "introBtn1",
                      "btnPressedImg": "introBtnPressed1",
                      "pageCtrlColor": "#19939b99"]
    
    let introInfo2 = ["title": "SEND US A MESSAGE!",
                      "image": "introImg2",
                      "description": "Contact hundreds of teachers and experts in various fields of study, ready to help you through your homework! Type, record your voice or send us a picture to ask your question any time of the day and recieve your answer within the next few minutes.",
                      "background": "background3",
                      "btnImg": "introBtn2",
                      "btnPressedImg": "introBtnPressed1",
                      "pageCtrlColor": "#d2752e99"]
    
    let introInfo3 = ["title": "PREPARE FOR TOEFL WRITING",
                      "image": "introImg3",
                      "description": "For those of you applying for the TOEFL test, the writing section might be a little difficult. In the \"Writing\" category, you can ask all of your questions relating the TOEFL writing section. You can simply send us a photo of your essay or attach  a PDF file and we will help you correct your grammatical, spelling or chioce of word errors.Don’t forget, your first 3 writing corrections are free of charge!",
                      "background": "background5",
                      "btnImg": "introBtn3",
                      "btnPressedImg": "introBtnPressed1",
                      "pageCtrlColor": "#c34c8899"]
    
    let introInfo4 = ["title": "your messages are archived!",
                      "image": "introImg4",
                      "description": "Check your History Log if you want to refer to your previous questions and answers. Just search a keyword and find the conversation you are looking for.Create an account and start right now!",
                      "background": "background4",
                      "btnImg": "introBtn4",
                      "btnPressedImg": "introBtnPressed1",
                      "pageCtrlColor": "#46917699"]

    var introInfoArray = [Dictionary<String,String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        introInfoArray = [introInfo1, introInfo2, introInfo3, introInfo4]
        
        introScrollView.isHidden = true
        introScrollView.isPagingEnabled = true

        introScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(introInfoArray.count), height: self.view.frame.height)

        introScrollView.showsHorizontalScrollIndicator = false
        loadIntroInfos()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if UserHelper.isAppAlreadyLaunchedOnce(){
//            self.performSegue(withIdentifier: "AfterIntroSegue", sender: self)
//        } else{
//            introScrollView.isHidden = false
//        }
        introScrollView.isHidden = false

    }
    
    func loadIntroInfos() {
        for (index, introInfo) in introInfoArray.enumerated(){
            if let introView = Bundle.main.loadNibNamed("Intro", owner: self, options: nil)?.first as? IntroView{
                introView.titleLabel.text = introInfo["title"]
                introView.imageView.image = UIImage(named: introInfo["image"]!)
                introView.discLbl.text = introInfo["description"]
                introView.addBackground(imageName: introInfo["background"]!, contentMode: .scaleToFill)
                
                introView.nextBtn.setImage(UIImage(named: introInfo["btnImg"]!), for: .normal)
                introView.nextBtn.setImage(UIImage(named: introInfo["btnPressedImg"]!), for: .highlighted)
                introView.nextBtn.tag = index
                introView.nextBtn.addTarget(self, action: #selector(self.changeScrollPage(sender:)), for: .touchUpInside)
                
                introView.pageCtrl.backgroundColor = UIColor(introInfo["pageCtrlColor"]!)
                introView.pageCtrl.currentPage = index

                introView.frame.size.height = self.view.bounds.height
                introView.frame.size.width = self.view.bounds.width
                introView.frame.origin.x = CGFloat(index) * self.view.bounds.width
                
                introScrollView.addSubview(introView)

            }
        }
    }

    @objc func changeScrollPage(sender: UIButton) {
        
        if (sender.tag + 1) == introInfoArray.count{
            self.performSegue(withIdentifier: "AfterIntroSegue", sender: self)
        }else{
            self.introScrollView.setCurrentPage(position: sender.tag+1)
        }
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
