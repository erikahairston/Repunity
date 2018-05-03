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
    
    func turnUrlToImg(urlStringl : String, messagedUser: Message)  {
        
        self.textLabel1.text = messagedUser.text
        if (urlStringl == "") || (urlStringl == "https://www.google.com/") {
            self.self.postImage.image = UIImage(named: "icons8-female-profile-filled-100.png")
            print("INIF printing photourl! \(urlStringl)")
        } else {
            print("IN ELSE printing photourl! \(urlStringl)")
            ImageService.getImage(withURL: URL.init(string: urlStringl)!) { (image) in
                self.postImage.image = image
            }
        }

    }
    
    func setMsgUsers(messagedUser: Message) {
        if checkIsCurrSender(messagedUser: messagedUser) {
            nameLabel.text = messagedUser.receiverName
            print("IN SET MSG USRE \(messagedUser.sentByID)")
            let url = URL(string: "https://repunity-8bf58.firebaseio.com/roleModels/\(messagedUser.sentToID)/photoURL.json")
            
            print("print url from setMsgUsers in msgcell \(url)")
            let task = URLSession.shared.dataTask(with: url!) {
                (data, response, error) in
                
                var photoUrl = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                //            self.currName = self.currName.replacingOccurrences(of: "\\/", with: "/")
                photoUrl = String(photoUrl.dropFirst())
                photoUrl = String(photoUrl.dropLast())
                print("printing photourl! \(photoUrl)")
                
                self.turnUrlToImg(urlStringl : photoUrl, messagedUser: messagedUser)
            
            }
            task.resume()
        }
        else {
            nameLabel.text = messagedUser.senderName
            let url = URL(string: "https://repunity-8bf58.firebaseio.com/roleModels/\(messagedUser.sentByID).json")
            
            let task = URLSession.shared.dataTask(with: url!) {
                (data, response, error) in
                
                var photoUrl = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                //            self.currName = self.currName.replacingOccurrences(of: "\\/", with: "/")
                photoUrl = String(photoUrl.dropFirst())
                photoUrl = String(photoUrl.dropLast())
                print("printing photourl! \(photoUrl)")
                
                self.turnUrlToImg(urlStringl : photoUrl, messagedUser: messagedUser)
              
            }
            task.resume()
        }
    }

//    func setMsgUsers(messagedUser: Message){
//        var photoURL = ""
//
//        //get the opposite person's name and photo
//        if checkIsCurrSender(messagedUser: messagedUser) {
//            nameLabel.text = messagedUser.receiverName
//            photoURL = messagedUser.getReceiverRoleModel().imgURL.absoluteString
//        } else {
//            nameLabel.text = messagedUser.senderName
//            photoURL = messagedUser.getSenderRoleModel().imgURL.absoluteString
//        }
//        textLabel1.text = messagedUser.text
//        if (photoURL != "") || photoURL != ("https://www.google.com/") {
//            postImage.image = UIImage(named: "icons8-female-profile-filled-100.png")
//        } else {
//            ImageService.getImage(withURL: URL.init(string: photoURL)!) { (image) in
//                self.postImage.image = image
//            }
//        }
//        print("SCOTT THIS IS PHOTO URL: \(photoURL)")
//    }
}
