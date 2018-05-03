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

    
    func checkIsCurrSender(messagedUser: Message) -> Bool {
        if Auth.auth().currentUser?.uid == messagedUser.sentByID {
            return true
        } else {
            return false
        }
    }
    func setMsgUsers(messagedUser: Message){
        var photoURL = ""
        
        //get the opposite person's name and photo
        if checkIsCurrSender(messagedUser: messagedUser) {
            nameLabel.text = messagedUser.receiverName
            photoURL = messagedUser.getReceiverRoleModel().imgURL.absoluteString
        } else {
            nameLabel.text = messagedUser.senderName
            photoURL = messagedUser.getSenderRoleModel().imgURL.absoluteString
        }
        textLabel1.text = messagedUser.text
        if (photoURL != "") || photoURL != ("https://www.google.com/") {
            postImage.image = UIImage(named: "icons8-female-profile-filled-100.png")
        } else {
            ImageService.getImage(withURL: URL.init(string: photoURL)!) { (image) in
                self.postImage.image = image
            }
        }
        print("SCOTT THIS IS PHOTO URL: \(photoURL)")
    }
}
