//
//  Message.swift
//  Repunity
//
//  Created by Erika Hairston on 5/2/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import Foundation
import UIKit


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
}
