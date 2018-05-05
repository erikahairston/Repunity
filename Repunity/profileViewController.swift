//
//  profileViewController.swift
//  Repunity
//
//  Created by Erika Hairston on 5/3/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit


class profileViewController: UIViewController {

    //variables
    var currRoleModel = RoleModel()
    
    //outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var jobAtCompanyLabel: UILabel!
    @IBOutlet weak var majorAtSchoolLabel: UILabel!
    @IBOutlet weak var supportGroups: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        if currRoleModel != nil {
            nameLabel.text = currRoleModel.name
            ImageService.getImage(withURL: currRoleModel.imgURL) { (image) in
                self.profileImageView.image = image
            }
            funFactLabel.text = "\"" + currRoleModel.funFact + "\""
            industryLabel.text = "In the " + currRoleModel.industry + " Industry"
            supportGroups.text = currRoleModel.relevantGroups
            jobAtCompanyLabel.text = currRoleModel.currOccupation + " at " + currRoleModel.currEmployer
            majorAtSchoolLabel.text =  currRoleModel.primaryMajor + " major at " + currRoleModel.undergradCollege
        }


        // Do any additional setup after loading the view.
    }
    
    //actions
    @IBAction func msgButtonClicked(_ sender: Any) {
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToChat" {
            let destinationVC = segue.destination as! detailMsgVC
            destinationVC.selectedUserToChat = currRoleModel
        }
    }
    

}
