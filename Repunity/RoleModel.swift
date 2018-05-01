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
    var name:String
    var img:String //make a url or uiimage?
    var funFact:String
    
    //ids
    var raceList = [String]() //to use
    var race:String
    var gender:String
    var isLGBTQ:Bool
    var isFirstGen:Bool
    
    //school info
    var undergradCollege:String
    var primaryMajor:String
    var gradYear:String //change to Int?
    
    //career info
    var industryList = [String]() // to use
    var industry:String
    var sector = "" //i.e. Nonprofit, profit to use
    var currOccupation:String
    var currEmployer:String
    var relevantGroups:String
    var resources = [String]()
    
    init(name:String, img:String, funFact:String, race:String, gender:String, isLGBTQ:Bool, isFirstGen:Bool, undergradCollege:String, primaryMajor:String, gradYear:String, industry:String, currOccupation:String, currEmployer:String, relevantGroups:String) {
        self.name = name
        self.img = img //to do
        self.funFact = funFact
        
        //ids
        self.race = race
        self.gender = gender
        self.isLGBTQ = isLGBTQ
        self.isFirstGen = isFirstGen
        
        //school info
        self.undergradCollege = undergradCollege
        self.primaryMajor = primaryMajor
        self.gradYear = gradYear
        
        //career info
        self.industry = industry
        self.currOccupation = currOccupation
        self.currEmployer = currEmployer
        self.relevantGroups = relevantGroups
        
        
    }
    
    
}
