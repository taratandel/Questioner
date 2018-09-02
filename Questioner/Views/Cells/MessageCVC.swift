//
//  MessageCVC.swift
//  Questioner
//
//  Created by negar on 97/Mordad/15 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class MessageCVC: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!

    override func awakeFromNib() {
        messageLbl.layer.cornerRadius = 10;
        messageLbl.clipsToBounds = true
    }

}
