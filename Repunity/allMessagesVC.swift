//
//  allMessagesVC.swift
//  Repunity
//
//  Created by Erika Hairston on 5/2/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class allMessagesVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //variables
    var msgdUsers = [Message]()
    var ref: DatabaseReference! = Database.database().reference()
    var currUserID = (Auth.auth().currentUser?.uid)!
    var chosenUser = RoleModel()

    var messages: [DataSnapshot]! = []


    fileprivate var _refHandle: DatabaseHandle!
    
    var storageRef: StorageReference!
    //var remoteConfig: RemoteConfig!

    
    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        observeUsersWithMsgs()
        tableView.reloadData()


        // Do any additional setup after loading the view.
    }
    
    //functions
    
    //add a listener to handle changes made to the database
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("messages").removeObserver(withHandle: _refHandle)
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
    }

    //generate List of all those you share a msg with
    func observeUsersWithMsgs()  {
        var msgIds = [String]()
        let resultsRef = Database.database().reference().child("messages")
        resultsRef.observe(.value, with: { snapshot in
            for child in snapshot.children {
                 if let childSnapshot = child as? DataSnapshot,
                let dict = childSnapshot.value as? [String: Any],
                let receiverName = dict["receiverName"] as? String,
                let senderName = dict["senderName"] as? String,
                let sentByID = dict["sentByID"] as? String,
                let sentToID = dict["sentToID"] as? String,
                let text = dict["text"] as? String{
                    
                    let singleMsg = Message(receiverName:receiverName, senderName:senderName, sentByID:sentByID, sentToID:sentToID, text:text)
                    
                    print("printerNAME: \(singleMsg.senderName)")
                    print("printing sender message: \(singleMsg.text)")
                    
                    print("printerRRRNAME: \(singleMsg.receiverName)")

                    //dont show duplicate ppl i'm talking to
                    if singleMsg.sentByID == self.currUserID {
                        if msgIds.contains(singleMsg.sentToID) {
                        
                            print("im in first if")
                        } else {
                            self.msgdUsers.append(singleMsg)
                            msgIds.append(singleMsg.sentToID)
                            print("im in first else")
                        }
                    }
                    if singleMsg.sentToID == self.currUserID {
                        if msgIds.contains(singleMsg.sentByID) {
                            print("im in second if")

                        } else {
                            self.msgdUsers.append(singleMsg)
                            msgIds.append(singleMsg.sentByID)
                            print("im in second else")

                        }
                    }
                }
            }
            print(self.currUserID)
            print(msgIds)
            self.tableView.reloadData()

        })
    }

        
//
//        // Unpack message from Firebase DataSnapshot
//        guard let message = messageSnapshot.value as? [String: String] else { return cell }
//        let name = message["name"]
//        let text = message["text"]
//        cell.textLabel?.text = name! + ": " + text!
//        cell.imageView?.image = UIImage(named: "icons8-female-profile-filled-100")
        

    
    //setup Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if msgdUsers.count == 0 {
            //TODO: print something cute like, try messaging RMS
            return 0
        } else {
            return msgdUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let chosenUserRm = RoleModel()
        if(msgdUsers[indexPath.row].sentByID == self.currUserID) {
            chosenUserRm.name = msgdUsers[indexPath.row].receiverName
            chosenUserRm.uuid = msgdUsers[indexPath.row].sentToID
        } else {
            chosenUserRm.name = msgdUsers[indexPath.row].senderName
            chosenUserRm.uuid = msgdUsers[indexPath.row].sentByID
        }
        self.chosenUser = chosenUserRm
        print("HHHHHHHH: \(self.chosenUser.uuid)")
        performSegue(withIdentifier: "toSpecificChat", sender: nil)
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! msgCell
        cell.setMsgUsers(messagedUser : msgdUsers[indexPath.row])
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSpecificChat" {
            let destinationVC = segue.destination as! detailMsgVC
            print(self.chosenUser.uuid)
            
            destinationVC.selectedUserToChat = self.chosenUser
            print("selectedUserToChat: \(self.chosenUser.name)")
        }
    }
}
    

