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
    fileprivate var _refHandle: DatabaseHandle!


    
    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("messages").removeObserver(withHandle: _refHandle)
        }
    }
    
    func getReceiver() -> (String, String) {
        //check who was clicked on and get their (ID, Name)
        
        return("s9mv8rq8ewfzEXg6sQ2HaqWobGx2","Eilaf")
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
        let (receiverID, receiverName) = getReceiver()
        mdata["senderName"] = "Johnny"
         mdata["receiverName"] = receiverName
//        if let photoURL = Auth.auth().currentUser?.photoURL {
//            mdata["photoURL"] = photoURL.absoluteString
//        }
        mdata["sentByID"] = (Auth.auth().currentUser?.uid)!
        mdata["sentToID"] = receiverID
        
        // Push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
    }
    
    //setup tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    //actions
    @IBAction func didSendMessage(_ sender: Any) {
        _ = textFieldShouldReturn(textField)
    }

}
