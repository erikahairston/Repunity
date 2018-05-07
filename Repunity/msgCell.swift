//
//  msgCell.swift
//  Repunity
//
//  Created by Erika Hairston on 5/2/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class msgCell: UITableViewCell {
    
    //variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var textLabel1: UILabel!
    
    //outlets

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //check if the current user is sending the msg to store correct Sender
    func checkIsCurrSender(messagedUser: Message) -> Bool {
        if Auth.auth().currentUser?.uid == messagedUser.sentByID {
            return true
        } else {
            return false
        }
    }
    
    func turnUrlToImg(urlStringl : String, messagedUser: Message)  {
        
        self.textLabel1.text = messagedUser.text
        if (urlStringl == "") || (urlStringl == "https://www.google.com/") {
            self.self.postImage.image = UIImage(named: "icons8-female-profile-filled-100.png")
        } else {
            ImageService.getImage(withURL: URL.init(string: urlStringl)!) { (image) in
                self.postImage.image = image
            }
        }
    }
    
    func setMsgUsers(messagedUser: Message) {
        if checkIsCurrSender(messagedUser: messagedUser) {
            nameLabel.text = messagedUser.receiverName
            self.turnUrlToImg(urlStringl: messagedUser.receiverPhotoURL, messagedUser: messagedUser)

        } else {
            nameLabel.text = messagedUser.senderName
            self.turnUrlToImg(urlStringl: messagedUser.senderPhotoURL, messagedUser: messagedUser)

        }
    }

}
