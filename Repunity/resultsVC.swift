//
//  resultsVC.swift
//  Repunity
//
//  Created by Erika Hairston on 4/25/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class resultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    //variables
    var resultModels = [RoleModel]()
    var category = ""
    var selectedResult = RoleModel()
    var notTopModel : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        //tableView.tableFooterView = UIView()
        tableView.reloadData()
        if category != "" {
            print("AND THE GAG IS: Category : \(category)")
            observeCatResults()

        } else if (notTopModel) {
             observeResults()
        }
    }
    
    
    //functions
    func getIdInd() -> (String, String) {
        var stringOfCatWords = self.category.components(separatedBy: " ")
        let resultId = stringOfCatWords[0]
        let resultIndustry =  stringOfCatWords[2]

        return(resultId,resultIndustry)
    }
    
    func checkIfMatchCat(possModel: RoleModel) -> Bool {
        let (resultId, resultIndustry) = getIdInd()
        
        if possModel.industry == resultIndustry {
            print("possIND: \(possModel.industry) , resultIND: \(resultIndustry)")
            if possModel.race == resultId {
                return true
            } else if possModel.gender == resultId {
                return true
            } else if possModel.isLGBTQ == true && resultId == "LGBTQ"{
                return true
            } else if possModel.isFirstGen == true && resultId == "firstGen" {
                return true
            }
        } else {
            return false
        }
        return false
    }
    
    //query relevant catorgies' roleModels and fill them ont he results page
    //instead of return all RoleModels, only return those from relevant segues
    func observeCatResults() {
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
                    
                    let resultRoleModel = RoleModel(uuid : uuid, name: name, imgURL: url, funFact: funFact, race: race, gender: gender, isLGBTQ: isLGBT, isFirstGen: isFirstGen, undergradCollege: college, primaryMajor: major_1, gradYear: gradYear, industry: industry_1, currOccupation: currOccupation, currEmployer: currEmployer, relevantGroups: relevantGroups)
                        
                    if self.checkIfMatchCat(possModel: resultRoleModel) {
                        tempResults.append(resultRoleModel)

                    } else {
                        continue
                    }
                }
            }
            
            self.resultModels = tempResults
            self.tableView.reloadData()
        })
        
    }
    
    func observeResults() {
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
                    tempResults.append(resultRoleModel)
                    
                }
            }
            
            self.resultModels = tempResults
            self.tableView.reloadData()
        })
        
    }
    
    //setup tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultModels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedResult = resultModels[indexPath.row]
        performSegue(withIdentifier: "resultToProfile", sender: nil)
    }
    
    //define cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! resultsCell
        cell.setResults(resultRoleModel: resultModels[indexPath.row])
        
        //let cell = UITableViewCell()
        // set values
        // cell.postText.text = postCommentArray[indexPath.row]
        //cell.userNameLabel.text = userEmailArray[indexPath.row]
        //cell.postImage.sd_setImage(with: URL(string: self.postImageURLArray[indexPath.row]))
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultToProfile" {
            let destinationVC = segue.destination as! profileViewController
            destinationVC.currRoleModel = selectedResult
        }
    }
    //actions
    

}
