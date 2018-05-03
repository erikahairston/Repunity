//
//  msgCell.swift
//  Repunity
//
//  Created by Erika Hairston on 5/2/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit

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
    
    //functions
    func setMsgUsers(messagedUser: Message){
        nameLabel.text = messagedUser.senderName
        textLabel1.text = messagedUser.text
        
        
    }
    
    
    //actions

}
