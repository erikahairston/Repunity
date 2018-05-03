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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMsgs(messagedUser: Message){
        var photoURL = ""
        
        // cell.textLabel?.text = name + ": " + text
        msgText.text = messagedUser.senderName + ": " + messagedUser.text
        photoURL = messagedUser.getSenderRoleModel().imgURL.absoluteString
        print("PHOTO URL in setMSGs insingleMsgCell: \(photoURL)")

        if photoURL == "" {
            self.userPicImageView.image = UIImage(named: "icons8-female-profile-filled-100.png")
        } else {
            ImageService.getImage(withURL: URL.init(string: photoURL)!) { (image) in
                self.userPicImageView.image = image
            }
        }
    }

}
