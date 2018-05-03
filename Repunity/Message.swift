//
//  Message.swift
//  Repunity
//
//  Created by Erika Hairston on 5/2/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class Message : Hashable {
    var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    var receiverName:String
    var senderName:String
    var sentByID:String
    
    var sentToID:String
    var text:String
    
    init(receiverName:String, senderName:String, sentByID:String, sentToID:String, text:String) {
        self.receiverName = receiverName
        self.senderName = senderName
        self.sentByID = sentByID
        self.sentToID = sentToID
        self.text = text
    }
    
    init() {
        receiverName = ""
        senderName = ""
        sentByID = ""
        sentToID = ""
        text = ""
    }
    
    //given a message, returns the RoleModel of the sender
    func getSenderRoleModel() -> RoleModel {
        var senderRM = RoleModel()
        let resultsRef = Database.database().reference().child("roleModels")
        resultsRef.queryOrdered(byChild: "uuid").queryEqual(toValue: self.sentByID).observeSingleEvent(of: .childAdded) { (snapshot) in
            snapshot
            
            let values = snapshot.value! as! NSDictionary
            senderRM.name = values["name"] as! String
            print("sender: \(senderRM.name)")
            senderRM.uuid = values["uuid"] as! String
            let asString = values["photoURL"]
            senderRM.imgURL  = URL.init(string: "asString")!
            senderRM.funFact = values["funFact"] as! String
            
            //ids
            senderRM.race = values["race"] as! String
            senderRM.gender = values["gender"] as! String
            senderRM.isLGBTQ = values["isLGBTQ"] as! Bool
            senderRM.isFirstGen = values["isFirstGen"] as! Bool
            
            //school info
            senderRM.undergradCollege = values["underGrad"] as! String
            senderRM.primaryMajor = values["primaryMajor"] as! String
            senderRM.gradYear = values["gradYear"] as! String
            
            //career info
            senderRM.industry = values["industry"] as! String
            senderRM.currOccupation = values["currJobTitle"] as! String
            senderRM.currEmployer = values["currEmployer"] as! String
            senderRM.relevantGroups = values["supportGroups"] as! String
        }
        return senderRM
    }
    //given a message, returns the RoleModel of the receiver
    func getReceiverRoleModel() -> RoleModel {
        var receiveRm = RoleModel()
        let resultsRef = Database.database().reference().child("roleModels")
        resultsRef.queryOrdered(byChild: "uuid").queryEqual(toValue: self.sentToID).observeSingleEvent(of: .childAdded) { (snapshot) in
            snapshot
            
            let values = snapshot.value! as! NSDictionary
            receiveRm.name = values["name"] as! String
            print("receiver: \(receiveRm.name)")
            receiveRm.uuid = values["uuid"] as! String
            print("VALUES UUID: \(values["uuid"] as! String)")

            print("receiver UUID: \(receiveRm.uuid)")

            let asString = values["photoURL"]
            receiveRm.imgURL  = URL.init(string: "asString")!
            receiveRm.funFact = values["funFact"] as! String
            
            //ids
            receiveRm.race = values["race"] as! String
            receiveRm.gender = values["gender"] as! String
            receiveRm.isLGBTQ = values["isLGBTQ"] as! Bool
            receiveRm.isFirstGen = values["isFirstGen"] as! Bool
            
            //school info
            receiveRm.undergradCollege = values["underGrad"] as! String
            receiveRm.primaryMajor = values["primaryMajor"] as! String
            receiveRm.gradYear = values["gradYear"] as! String
            
            //career info
            receiveRm.industry = values["industry"] as! String
            receiveRm.currOccupation = values["currJobTitle"] as! String
            receiveRm.currEmployer = values["currEmployer"] as! String
            receiveRm.relevantGroups = values["supportGroups"] as! String
        }
        return receiveRm
    }
}
