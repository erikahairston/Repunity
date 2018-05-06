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
    @IBOutlet weak var coverPhotoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        coverPhotoImage.image = rotateCoverImage()
    
        nameLabel.text = currRoleModel.name
        ImageService.getImage(withURL: currRoleModel.imgURL) { (image) in
            self.profileImageView.image = image
            self.profileImageView.layer.borderWidth = 1
            self.profileImageView.layer.masksToBounds = false
            //self.profileImageView.layer.borderColor = UIColor.black.cgColor
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
            self.profileImageView.clipsToBounds = true
            }
        funFactLabel.text = "\"" + currRoleModel.funFact + "\""
        industryLabel.text = "In the " + currRoleModel.industry + " Industry"
        supportGroups.text = "Supportive Groups: " + currRoleModel.relevantGroups
        jobAtCompanyLabel.text = "Experience: " + currRoleModel.currOccupation + " at " + currRoleModel.currEmployer
        majorAtSchoolLabel.text = "Education: " + currRoleModel.primaryMajor + " major at " + currRoleModel.undergradCollege
    }
    
    //actions
    @IBAction func msgButtonClicked(_ sender: Any) {
    }
    
    //functions
    func rotateCoverImage() -> UIImage {
        var chosenPhoto = UIImage()
        var possPhotos = ["blue_cover.jpg", "cloud_cover.jpg", "kelli-tungay-324329-unsplash.jpg", "nathan-anderson-109933-unsplash.jpg", "yellow_cover.jpg"]
        let numPhotos = possPhotos.count - 1
        let randIndx = Int(arc4random_uniform(UInt32(numPhotos)))
        chosenPhoto = UIImage(named: possPhotos[randIndx])!
        return chosenPhoto
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToChat" {
            let destinationVC = segue.destination as! detailMsgVC
            destinationVC.selectedUserToChat = currRoleModel
        }
    }
}
