//
//  FirstViewController.swift
//  Repunity
//
//  Created by Erika Hairston on 4/24/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class homeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //variables
    var topModels = [RoleModel]()
    
    //outlests
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currJobLabel: UILabel!
    @IBOutlet weak var employerLabel: UILabel!
    
    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var spotLightImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        observeTopResults()
        
    }
    
    //actions

    
    //functions
    
    //# of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return topModels.count
    }
    
    //populate cell views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath) as! topModelCell
        cell.setTopValues(resultRoleModel: topModels[indexPath.row])
        return cell
    }
    
    
    //top role_models ranking func
    /*every time the app is opened i iterate thru every other user giving them a score based on their attributes in relation to the current user */
    func observeTopResults() {
        let resultsRef = Database.database().reference().child("roleModels")
        resultsRef.observe(.value, with: { snapshot in
            var tempResults = [RoleModel]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let uuid = dict["uudid"] as? String,
                    let name = dict["name"] as? String,
                    let race = dict["race"] as? String,
                    let gender = dict["gender"] as? String,
                    let isLGBT = dict["isLGBTQ"] as? Bool,
                    let isFirstGen = dict["isFirstGen"] as? Bool,
                    let college = dict["underGrad"] as? String,
                    let major_1 = dict["primaryMajor"] as? String,
                    let gradYear = dict["gradYear"] as? String,
                    let photoURL = dict["photoURL"] as? String,
                    let url = URL(string:photoURL),
                    let funFact = dict["funFact"] as? String,
                    let industry_1 = dict["industry"] as? String,
                    let currEmployer = dict["currEmployer"] as? String,
                    let currOccupation = dict["currJobTitle"] as? String,
                    let relevantGroups = dict["supportGroups"] as? String {
                    
                    let resultRoleModel = RoleModel(uuid: uuid, name: name, imgURL: url, funFact: funFact, race: race, gender: gender, isLGBTQ: isLGBT, isFirstGen: isFirstGen, undergradCollege: college, primaryMajor: major_1, gradYear: gradYear, industry: industry_1, currOccupation: currOccupation, currEmployer: currEmployer, relevantGroups: relevantGroups)
                    
                    if resultRoleModel.uuid == (Auth.auth().currentUser?.uid)! {
                        continue
                    } else {
                        tempResults.append(resultRoleModel)
                    }
                    
                }
            }
            let sortedRMs = self.assignScores(rankingModels : tempResults)
        
            self.topModels = sortedRMs
            self.collectionView.reloadData()
        })
        
    }
    
 
    func assignScores(rankingModels : [RoleModel]) -> [RoleModel] {
        var matchScore = [RoleModel : Int]()
        var score = 0
        for eachRm in rankingModels {
            
            score = calculateScore(compareRm : eachRm)
            matchScore[eachRm] = score
        }
        
        let sortedRoleModels = Array(matchScore.keys).sorted(by: {matchScore[$0]! < matchScore[$1]!})
        print("SORTED ROLEMODELS BELOW")
        print(sortedRoleModels)
        return sortedRoleModels
    }
    
    func calculateScore(compareRm: RoleModel) -> Int {
        var score = 0
        //if Auth.auth().currentUser?.uid
        
        return score
        
    }
    

}

