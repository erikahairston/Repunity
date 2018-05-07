//
//  accountVC.swift
//  Repunity
//
//  Created by Erika Hairston on 4/24/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class accountVC: UIViewController {
    
    //variables
    var currUser = RoleModel()
    
    //outlets
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var logInSignUpButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var inudstryLabel: UILabel!
    @IBOutlet weak var collegeMajor: UILabel!
    @IBOutlet weak var underGradCollege: UILabel!
    @IBOutlet weak var groups: UILabel!
    @IBOutlet weak var funFactLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user : String? = UserDefaults.standard.string(forKey: "user")
        if user == nil {
            logOutButton.isHidden = true
            logInSignUpButton.isHidden = false
        } else {
            logOutButton.isHidden = false
            logInSignUpButton.isHidden = true
        }
        
        observeCurrRM()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }
    
    //actions
    @IBAction func logoutClicked(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
        
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC 
        
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = signIn
        
        delegate.rememberLogin()
    }
    
    @IBAction func logInorSignUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "accountToLogIn", sender: nil)
    }
    
    //retrieve the current user's RoleModel attribute values
    func observeCurrRM() {
        let resultsRef = Database.database().reference().child("roleModels")
        resultsRef.observe(.value, with: { snapshot in
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
                        self.currUser = resultRoleModel
                        self.nameLabel.text = self.currUser.name
                        ImageService.getImage(withURL: self.currUser.imgURL) { (image) in
                            self.profileImageView.image = image
                        }
                        self.funFactLabel.text = self.currUser.funFact
                        self.underGradCollege.text = self.currUser.undergradCollege
                        self.inudstryLabel.text = self.currUser.industry
                        self.collegeMajor.text = self.currUser.primaryMajor
                        self.groups.text = self.currUser.relevantGroups

                    } else {
                        continue
                    }
                }
            }
        })
    }


}
