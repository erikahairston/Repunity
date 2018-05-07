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
    var selectedTopModel = RoleModel()
    var sortedRMs = [RoleModel]()
    var rmsWithScores = [RoleModel : Int]()
    
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
    @IBAction func showAllButtonClicked(_ sender: Any) {
        //Segue(withIdentifier: "homeToTopResults", sender: nil)
    }
    
    
    //functions
    func pickSpotlight(countedRMs : Int) -> Int {
        let diceRoll = Int(arc4random_uniform(UInt32(countedRMs)))
        print("dice roll int: \(countedRMs)")
        return diceRoll
    }
    
    func observeSpotlight(passedRoleModel : RoleModel) {
        nameLabel.text = passedRoleModel.name
        currJobLabel.text = passedRoleModel.currOccupation
        employerLabel.text = passedRoleModel.currEmployer
        funFactLabel.text = passedRoleModel.funFact
        ImageService.getImage(withURL: passedRoleModel.imgURL) { (image) in
           self.spotLightImg.image = image
        }
        
    }
    
    //# of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if topModels.count == 0 {
            //TODO: return something cute
            return 0
        }
        return topModels.count
    }
    
    //populate cell views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath) as! topModelCell
        let currTM = topModels[indexPath.row]
        cell.setTopValues(resultRoleModel: currTM)
        cell.inCommonText.text = "Match Score:" + String(rmsWithScores[currTM]! )
        cell.layer.masksToBounds = true;
        cell.layer.cornerRadius = 3
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         selectedTopModel = topModels[indexPath.row]
        performSegue(withIdentifier: "toTopRMProPic", sender: nil)
    }
    
    
    //top role_models ranking func
    /*every time the app is opened i iterate thru every other user giving them a score based on their attributes in relation to the current user */
    func observeTopResults() {
        var currentUser = RoleModel()
        let resultsRef = Database.database().reference().child("roleModels")
        resultsRef.observe(.value, with: { snapshot in
            var tempResults = [RoleModel]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let uuid = dict["uuid"] as? String,
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
                        currentUser = resultRoleModel
                    } else {
                        tempResults.append(resultRoleModel)
                    }
                }
            }
            (self.sortedRMs, self.rmsWithScores) = self.assignScores(rankingModels : tempResults, nowUser : currentUser)
            self.topModels = self.sortedRMs
            self.collectionView.reloadData()
            
            let newRM = tempResults[self.pickSpotlight(countedRMs: tempResults.count)]
            self.observeSpotlight(passedRoleModel: newRM)
        })
    }
    
    //given current user, compares their RoleModel attributes to every other one to give a score to each
    func assignScores(rankingModels : [RoleModel], nowUser : RoleModel) -> ([RoleModel], [RoleModel : Int]) {
        var matchScore = [RoleModel : Int]()
        var score = 0
        var topTenRMs = [RoleModel]()
        for eachRm in rankingModels {
            
            score = calculateScore(compareRm : eachRm, nowUser1: nowUser)
            matchScore[eachRm] = score
        }
        
        let sortedRoleModels = Array(matchScore.keys).sorted(by: {matchScore[$0]! > matchScore[$1]!})
        if sortedRoleModels.count > 10 {
            for count in 0...9 {
                topTenRMs.append(sortedRoleModels[count])
            }
            return (topTenRMs, matchScore)
        } else {
            return (sortedRoleModels, matchScore)
        }
    }
    
    //scoring algorithm
    func calculateScore(compareRm: RoleModel, nowUser1: RoleModel) -> Int {
        var score = 0
        if nowUser1.race == compareRm.race {
//            print("nowUser1.race = \(nowUser1.race) compareRm.race = \(compareRm.race)")
            score = score + 5
        }
        if nowUser1.gender == compareRm.gender {
//            print("nowUser1.gender = \(nowUser1.gender) compareRm.race = \(compareRm.gender)")

            score = score + 5
        }
        if nowUser1.industry == compareRm.industry {
//            print("nowUser1.industry = \(nowUser1.industry) compareRm.industry = \(compareRm.industry)")

            score = score + 5
        }
        if nowUser1.primaryMajor == compareRm.primaryMajor {
//            print("nowUser1.primaryMajor = \(nowUser1.primaryMajor) ompareRm.primaryMajor = \(compareRm.primaryMajor)")

            score = score + 5
        }
        if nowUser1.isLGBTQ && compareRm.isLGBTQ {
//            print("nowUser1.isLGBTQ = \(nowUser1.isLGBTQ) compareRm.isLGBTQ = \(compareRm.isLGBTQ)")

            score = score + 5
        }
        if nowUser1.isFirstGen && compareRm.isFirstGen {
//            print("nowUser1.isFirstGen = \(nowUser1.isFirstGen) compareRm.isFirstGen = \(compareRm.isFirstGen)")

            score = score + 5
        }
//        print("score of \(compareRm.name) is \(score)")
        return score
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToTopResults" {
            let destinationVC = segue.destination as! resultsVC
            destinationVC.resultModels = topModels
            destinationVC.notTopModel = false
        }
        
        if segue.identifier == "toTopRMProPic" {
            let destinationProfVC = segue.destination as! profileViewController
            destinationProfVC.currRoleModel = self.selectedTopModel
        }
    }
    

}

