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
    
            //mock data
   /*  var resultModels = [
        RoleModel(name: "Scott", img: "", funFact: "I Love Pizza almost as much as my amazing gf", race: "Black", gender: "Male", isLGBTQ: false, isFirstGen: false, undergradCollege: "NYIT", primaryMajor: "CompSci", gradYear: "2017", industry: "tech", currOccupation: "SWE", currEmployer: "Snap", relevantGroups: "NSBE, BlackValley, Code2040"),
         RoleModel(name: "Erika", img: "", funFact: "Santa is Great and I believed in him until i was 13", race: "Black", gender: "Female", isLGBTQ: false, isFirstGen: false, undergradCollege: "Yale", primaryMajor: "CompSci", gradYear: "2018", industry: "tech", currOccupation: "APM", currEmployer: "LinkedIn", relevantGroups: "Black Tech Women, BlackValley")
    
    ] */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        observeResults()
    }
    
    
    //functions
    func observeResults() {
        let resultsRef = Database.database().reference().child("roleModels")
        resultsRef.observe(.value, with: { snapshot in
            var tempResults = [RoleModel]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
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
                    
                    let resultRoleModel = RoleModel(name: name, img: photoURL, funFact: funFact, race: race, gender: gender, isLGBTQ: isLGBT, isFirstGen: isFirstGen, undergradCollege: college, primaryMajor: major_1, gradYear: gradYear, industry: industry_1, currOccupation: currOccupation, currEmployer: currEmployer, relevantGroups: relevantGroups)
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
    
    //actions
    

}
