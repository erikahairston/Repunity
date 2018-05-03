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

class detailMsgVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
            print("HERE ARE MSGS")
            print(snapshot.value!)
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let receiverName = dict["receiverName"] as? String,
                    let senderName = dict["senderName"] as? String,
                    let sentByID = dict["sentByID"] as? String,
                    let sentToID = dict["sentToID"] as? String,
                    let text = dict["text"] as? String{
                    
                    let singleMsg = Message(receiverName:receiverName, senderName:senderName, sentByID:sentByID, sentToID:sentToID, text:text)
                    print(singleMsg.senderName)
                    
                    //only show msgs between the curr and selected users
                 /*   (sentBy = CurrUser && sentTo = You
                        or
                        sentBy = You && sentTo = Me) */
                    
                    if (singleMsg.sentByID  == self.currUserID) && (singleMsg.sentToID == self.selectedUserToChat.uuid) {
                        self.ourMessages.append(singleMsg)
                        print("first instance 1")
                        print(self.selectedUserToChat.uuid)
                    } else {
                    if (singleMsg.sentByID  == self.selectedUserToChat.uuid) && (singleMsg.sentToID == self.currUserID) {
                        self.ourMessages.append(singleMsg)
                        print("second instance 2")
                        print(self.selectedUserToChat.uuid)

                    } else {
                        print("third instance 3")
                        print(self.selectedUserToChat.uuid)

                        }
                    }
                }
            }
            print("All our messages here")
            print(self.ourMessages)
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
        print("https://repunity-8bf58.firebaseio.com/roleModels/\(self.currUserID)/name.json")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            print("printing response")
            self.currName = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            self.currName = self.currName.replacingOccurrences(of: "\\/", with: "/")
            

            
            let resultsRef = Database.database().reference().child("roleModels")
            resultsRef.queryOrdered(byChild: "uuid").queryEqual(toValue: self.currUserID)
                .observeSingleEvent(of: .value) { (snapshot) in
                    
                    let values = snapshot.value! as! NSDictionary
                    print("values print!!!")
                    print("values!!!: \(values)")
                    
                    if values["name"] != nil {
                        self.currName = values["name"] as! String
                        print("inside if!")
                        print("sender!!!: \(self.currName)")
                    }
                    print("sender!!!: \(self.currName)")
                    
            }
            print("sender!BOO!!: \(self.currName)")

        }
        
        task.resume()
//        return self.currName

        
    }
 

    
    // UITextViewDelegate protocol methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        textField.text = ""
        view.endEditing(true)
        let data = ["text": text]
        sendMessage(withData: data)
        return true
    }

    
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        self.ourMessages = []
        let (receiverID, receiverName) = getReceiver()
        
        let url = URL(string: "https://repunity-8bf58.firebaseio.com/roleModels/\(self.currUserID)/name.json")
        print("https://repunity-8bf58.firebaseio.com/roleModels/\(self.currUserID)/name.json")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            print("printing response")
            
            self.currName = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//            self.currName = self.currName.replacingOccurrences(of: "\\/", with: "/")
            self.currName = String(self.currName.dropFirst())
            self.currName = String(self.currName.dropLast())
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
//                let posts = json["name"] as? [[String: Any]] ?? []
//                print("printing posts")
//                print(posts)
//
//            } catch let error as NSError
//            {
//                print(error)
//            }
            
            // print("sender name before save: \(getSender())")
             mdata["senderName"] = self.currName
             mdata["receiverName"] = receiverName
            print("receiver name")
            print(receiverName)
            print("receiver name mdata")
            print(mdata["receiverName"] as String?)
    //        if let photoURL = Auth.auth().currentUser?.photoURL {
    //            mdata["photoURL"] = photoURL.absoluteString
    //        }
            mdata["sentByID"] = (Auth.auth().currentUser?.uid)!
            print("sent BY ID: \((Auth.auth().currentUser?.uid)!)")
            mdata["sentToID"] = receiverID
            
            // Push data to Firebase Database
            self.ref.child("messages").childByAutoId().setValue(mdata)
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
