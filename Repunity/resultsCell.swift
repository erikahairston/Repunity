//
//  resultsCell.swift
//  Repunity
//
//  Created by Erika Hairston on 4/25/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit

class resultsCell: UITableViewCell {

    //variables
    
    //outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var funFactText: UITextView!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var currPositionLabel: UILabel!
    @IBOutlet weak var currEmployerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //actions
    
    //functions
    func setResults(resultRoleModel: RoleModel){
        nameLabel.text = resultRoleModel.name
        ImageService.getImage(withURL: resultRoleModel.imgURL) { (image) in
            self.profileImageView.image = image
        }
        //profileImageView.image =
        funFactText.text = resultRoleModel.funFact
        collegeLabel.text = resultRoleModel.undergradCollege
        currPositionLabel.text = resultRoleModel.currOccupation
        currEmployerLabel.text = resultRoleModel.currEmployer
        
    }

}
