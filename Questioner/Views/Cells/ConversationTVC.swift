//
//  ConversationTVC.swift
//  Questioner
//
//  Created by negar on 97/Azar/13 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class ConversationTVC: UITableViewCell {

    var conversationId = ""
    var questionType = ""
    var isEnd = false

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
