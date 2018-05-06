//
//  detailMsgVC.swift
//  Repunity
//
//  Created by Erika Hairston on 5/2/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class detailMsgVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //variables
    var selectedUserToChat = RoleModel()
    var ref: DatabaseReference! = Database.database().reference()
    var currUserID = (Auth.auth().currentUser?.uid)!
    fileprivate var _refHandle: DatabaseHandle!
    var ourMessages = [Message]()
    var currName = ""


    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.textField.delegate = self
        tableView.reloadData()
        
        observeMsgsWithUser()
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("messages").removeObserver(withHandle: _refHandle)
        }
    }
    
    
    //generate List of all the msgs u share with this user
    func observeMsgsWithUser() {
        let resultsRef = Database.database().reference().child("messages")
        resultsRef.observe(.value, with: { snapshot in
            self.ourMessages = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let receiverName = dict["receiverName"] as? String,
                    let senderName = dict["senderName"] as? String,
                    let sentByID = dict["sentByID"] as? String,
                    let sentToID = dict["sentToID"] as? String,
                    let senderPhotoURL = dict["senderPhotoURL"] as? String,
                    let receiverPhotoURL = dict["receiverPhotoURL"] as? String,
                    let text = dict["text"] as? String{
                    
                    let singleMsg = Message(receiverName:receiverName, senderName:senderName, sentByID:sentByID, sentToID:sentToID, text:text, senderPhotoURL:senderPhotoURL, receiverPhotoURL:receiverPhotoURL)
                    
                    //only show msgs between the curr and selected users
                    if (singleMsg.sentByID  == self.currUserID) && (singleMsg.sentToID == self.selectedUserToChat.uuid) {
                        self.ourMessages.append(singleMsg)
                    } else {
                        if (singleMsg.sentByID  == self.selectedUserToChat.uuid) && (singleMsg.sentToID == self.currUserID) {
                            self.ourMessages.append(singleMsg)
                        }
                    }
                }
            }
            self.tableView.reloadData()
            
        })
    }
    
    func getReceiver() -> (String, String) {
        //check who was clicked on and get their (ID, Name)
        let receiverName = selectedUserToChat.name
        let receiverID = selectedUserToChat.uuid
        return(receiverID,receiverName)
    }
    
    func getSender() -> Void {
        
        let url = URL(string: "https://repunity-8bf58.firebaseio.com/roleModels/\(self.currUserID)/name.json")
    
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            self.currName = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            self.currName = self.currName.replacingOccurrences(of: "\\/", with: "/")
            
            let resultsRef = Database.database().reference().child("roleModels")
            resultsRef.queryOrdered(byChild: "uuid").queryEqual(toValue: self.currUserID)
                .observeSingleEvent(of: .value) { (snapshot) in
                    
                    let values = snapshot.value! as! NSDictionary
                    if values["name"] != nil {
                        self.currName = values["name"] as! String
                    }
            }
        }
        task.resume()
    }
 

    
    // UITextViewDelegate protocol methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        textField.text = ""
        self.view.endEditing(true)
        let data = ["text": text]
        sendMessage(withData: data)
        return true
    }

    
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        self.ourMessages = []
        let (receiverID, receiverName) = getReceiver()
        
        let url = URL(string: "https://repunity-8bf58.firebaseio.com/roleModels.json")
        print("https://repunity-8bf58.firebaseio.com/roleModels/\(self.currUserID)/name.json")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            print("printing response")
            
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let senderRoleModel = json[self.currUserID] as! [String: Any]
                let receiverRoleModel = json[receiverID] as! [String: Any]
                
                self.currName = (senderRoleModel["name"] as? String)!

                mdata["senderName"] = self.currName
                mdata["receiverName"] = receiverName
        
                if let photoURL = Auth.auth().currentUser?.photoURL {
                    mdata["senderPhotoURL"] = photoURL.absoluteString
                }
                
                mdata["receiverPhotoURL"] = receiverRoleModel["photoURL"] as! String
                mdata["sentByID"] = (Auth.auth().currentUser?.uid)!
                mdata["sentToID"] = receiverID
                
                // Push data to Firebase Database
                self.ref.child("messages").childByAutoId().setValue(mdata)
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }
    
    //setup tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ourMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleMsgCell", for: indexPath) as! singleMsgCell
        print("ourMessages: TABLEVIEW")
        print(self.ourMessages)
            cell.setMsgs(messagedUser : self.ourMessages[indexPath.row])
        return cell
    }
    
    //actions
    @IBAction func didSendMessage(_ sender: Any) {
        _ = textFieldShouldReturn(textField)
    }
}
