//
//  role_model.swift
//  Repunity
//
//  Created by Erika Hairston on 4/29/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import Foundation
import UIKit

class RoleModel {
    var name = ""
    var img = UIImage()
    var funFact = ""
    
    //ids
    var race = [String]()
    var gender = ""
    var isLGBT = false
    var isFirstGen = false
    
    //school info
    var undergradCollege = ""
    var primaryMajor = ""
    var gradYear: Int = 0
    
    //career info
    var industry = [String]()
    var sector = "" //i.e. Nonprofit, profit
    var currOccupation = ""
    var currEmployer = ""
    var relevantGroups = [String]()
    var resources = [String]()
    
    
}
