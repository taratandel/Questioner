//
//  HistoryVC.swift
//  Questioner
//
//  Created by negar on 97/Azar/13 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageDelegate{

    let defaults = UserDefaults.standard
    let messageHelper = MessageHelper()

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var conversationsTable: UITableView!
    var conversations = [Conversation()]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        conversationsTable.delegate = self
        conversationsTable.dataSource = self
        conversationsTable.isHidden = true

        indicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getConversations() {
        if (defaults.object(forKey: "StudentData") != nil){
            let stdData = defaults.object(forKey: "StudentData") as! Student
            if stdData.active{
                let stdPhone = stdData.phone
                messageHelper.getConversation(studentId: stdPhone)
            }else{
                ViewHelper.showToastMessage(message: "your account isn't active.")
            }
        }else{
            ViewHelper.showToastMessage(message: "please login!")
        }

    }

    func getConversationsSuccessfully(conversations: [Conversation]) {
        self.conversations = conversations
        conversationsTable.reloadData()
        indicator.isHidden = true
        indicator.stopAnimating()
        conversationsTable.isHidden = false
    }

    func getMessagesUnsuccessfully(error: String) {
        ViewHelper.showToastMessage(message: error)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTVC
        let conversation = conversations[indexPath.row]
        cell.nameLbl.text = conversation.name
        cell.dateLbl.text = conversation.date
        cell.conversationId = conversation.conversationId
        cell.isEnd = conversation.isEnd
        cell.questionType = conversation.questionType
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ConversationTVC
        let chatVC = SegueHelper.createViewController(storyboardName: "Main", viewControllerId: "ChatVC") as! ChatVC
        chatVC.conversationId = cell.conversationId
        switch cell.questionType {
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
