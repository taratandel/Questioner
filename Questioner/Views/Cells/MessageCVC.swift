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

    var message = Message()
    var type = typeEnum.none

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.opacity = 1

        messageLbl.layer.cornerRadius = 10
        messageLbl.clipsToBounds = true

        messageLbl.text = " " + message.message
        nameLbl.text = message.name
        timeLbl.text = message.timeStamp

        switch type {
        case .english:
            nameLbl.textColor = UIColor("#66320F99")
            timeLbl.textColor = UIColor("#AF371699")
        case .math:
            nameLbl.textColor = UIColor("#455D2099")
            timeLbl.textColor = UIColor("#95C45799")
        case .science:
            nameLbl.textColor = UIColor("#47184C99")
            timeLbl.textColor = UIColor("#66408A99")
        case .toefl:
            nameLbl.textColor = UIColor("#1C3E5C99")
            timeLbl.textColor = UIColor("#175D9999")
        default:
            break
        }
    }

}


class ImageMessageCVC : UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var imageCell: UIImageView!

    var message = Message()
    var parentVC = ChatVC()
    var type = typeEnum.none

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.opacity = 1

        imageCell.layer.cornerRadius = 10;
        imageCell.clipsToBounds = true

        nameLbl.text = message.name
        timeLbl.text = message.timeStamp

        switch type {
        case .english:
            nameLbl.textColor = UIColor("#66320F99")
            timeLbl.textColor = UIColor("#AF371699")
        case .math:
            nameLbl.textColor = UIColor("#455D2099")
            timeLbl.textColor = UIColor("#95C45799")
        case .science:
            nameLbl.textColor = UIColor("#47184C99")
            timeLbl.textColor = UIColor("#66408A99")
        case .toefl:
            nameLbl.textColor = UIColor("#1C3E5C99")
            timeLbl.textColor = UIColor("#175D9999")
        default:
            break
        }

    }

    @IBAction func loadData(_ sender: Any) {
        let imageVC = SegueHelper.createViewController(storyboardName: "Main", viewControllerId: "imagePreview") as! ImageVC
        imageVC.imageContent = imageCell.image!
        SegueHelper.presentViewController(sourceViewController: parentVC, destinationViewController: imageVC)
    }
    func showImage() {
        if message.image.count == 0{
            imageCell.image = UIImage(named: "noImg")
        }else{
            do {
                let url = URL(string: message.image)
                let data = try Data(contentsOf: url!)
                self.imageCell.image = UIImage(data: data)
            }catch{
                imageCell.image = UIImage(named: "noImg")
            }
        }
    }

}

protocol ContactAndVoiceMessageCellProtocol: class {
    func cellDidTapedVoiceButton(_ cell: VoiceMessageCVC, isPlayingVoice: Bool, index: Int)
}

class VoiceMessageCVC: UICollectionViewCell {

    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var playVoiceButton: UIButton!

    weak var delegate: ContactAndVoiceMessageCellProtocol?
    weak var parentVeiwController: ChatVC?

    var message = Message()
    var indexpathraw = Int()
    var type = typeEnum.none

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.opacity = 1

        grayView.layer.cornerRadius = 10;
        grayView.clipsToBounds = true

        nameLbl.text = message.name
        timeLbl.text = message.timeStamp

        switch type {
        case .english:
            nameLbl.textColor = UIColor("#66320F99")
            timeLbl.textColor = UIColor("#AF371699")
        case .math:
            nameLbl.textColor = UIColor("#455D2099")
            timeLbl.textColor = UIColor("#95C45799")
        case .science:
            nameLbl.textColor = UIColor("#47184C99")
            timeLbl.textColor = UIColor("#66408A99")
        case .toefl:
            nameLbl.textColor = UIColor("#1C3E5C99")
            timeLbl.textColor = UIColor("#175D9999")
        default:
            break
        }

    }

    @IBAction func playVoice(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let delegate = self.delegate else { return }
        delegate.cellDidTapedVoiceButton(self, isPlayingVoice: sender.isSelected, index: indexpathraw)
    }
<<<<<<< HEAD

    func resetVoiceAnimation(audioPlayStatus: AudioPlayerStatus) {
        switch audioPlayStatus {
        case .start:
            playVoiceButton.setTitle("playing voice", for: .selected)
        case .finished:
            playVoiceButton.setTitle("playing audio", for: .normal)
            playVoiceButton.isSelected = false
        case .failed:
            ViewHelper.showToastMessage(message: "Unable to play sound")
        default:
            playVoiceButton.setTitle("playing audio", for: .normal)
            playVoiceButton.isSelected = false
        }
    }
=======
>>>>>>> 99b54d42abbfdd35c1c7c7f8c90a33eb768655ca
}
