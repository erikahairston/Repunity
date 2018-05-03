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
    var currRoleMOdel = RoleModel()
    
    //outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var supportiveGroupsLabel: UILabel!
    @IBOutlet weak var funFactLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        if currRoleMOdel != nil {
            nameLabel.text = currRoleMOdel.name
            ImageService.getImage(withURL: currRoleMOdel.imgURL) { (image) in
                self.profileImageView.image = image
            }
            funFactLabel.text = currRoleMOdel.funFact
            collegeLabel.text = currRoleMOdel.undergradCollege
            industryLabel.text = currRoleMOdel.industry
            majorLabel.text = currRoleMOdel.primaryMajor
            supportiveGroupsLabel.text = currRoleMOdel.relevantGroups
        }


        // Do any additional setup after loading the view.
    }
    
    //actions
    @IBAction func msgButtonClicked(_ sender: Any) {
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToChat" {
            let destinationVC = segue.destination as! detailMsgVC
            destinationVC.selectedUserToChat = currRoleMOdel
        }
    }
    

}
