//
//  singleMsgCell.swift
//  Repunity
//
//  Created by Erika Hairston on 5/3/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class singleMsgCell: UITableViewCell {

   //variables
   
    //outlets
    @IBOutlet weak var msgText: UILabel!
    @IBOutlet weak var userPicImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //functions to set views of the single msgs
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMsgs(messagedUser: Message){
        self.msgText.text = messagedUser.senderName + ": " + messagedUser.text

        if messagedUser.senderPhotoURL == "" {
            self.userPicImageView.image = UIImage(named: "icons8-female-profile-filled-100.png")
        } else {
            ImageService.getImage(withURL: URL.init(string: messagedUser.senderPhotoURL)!) { (image) in
                self.userPicImageView.image = image
            }
        }
        }

}
