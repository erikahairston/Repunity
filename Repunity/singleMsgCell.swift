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
        let url = URL(string: "https://repunity-8bf58.firebaseio.com/roleModels/\(messagedUser.sentByID)/photoURL.json")
        
        print("print url from setMsgUsers in msgcell \(url)")
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            
            var photoUrl = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            //            self.currName = self.currName.replacingOccurrences(of: "\\/", with: "/")
            photoUrl = String(photoUrl.dropFirst())
            photoUrl = String(photoUrl.dropLast())
            print("printing photourl! \(photoUrl)")
            
            // cell.textLabel?.text = name + ": " + text
            self.msgText.text = messagedUser.senderName + ": " + messagedUser.text
            print("PHOTO URL in setMSGs insingleMsgCell: \(photoUrl)")
            
            if photoUrl == "" {
                self.userPicImageView.image = UIImage(named: "icons8-female-profile-filled-100.png")
            } else {
                ImageService.getImage(withURL: URL.init(string: photoUrl)!) { (image) in
                    self.userPicImageView.image = image
                }
        }
        }
        task.resume()
        }

}
