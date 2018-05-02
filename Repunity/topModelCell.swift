//
//  topModelCell.swift
//  Repunity
//
//  Created by Erika Hairston on 5/1/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit

class topModelCell: UICollectionViewCell {
    
    //variables
    
    //outlets
    @IBOutlet weak var myTopImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currPositionLabel: UILabel!
    @IBOutlet weak var currEmployerLabel: UILabel!
    @IBOutlet weak var currIndustry: UILabel!
    
    func setTopValues(resultRoleModel: RoleModel){
        nameLabel.text = resultRoleModel.name
        ImageService.getImage(withURL: resultRoleModel.imgURL) { (image) in
            self.myTopImageView.image = image
        }
        currPositionLabel.text = resultRoleModel.currOccupation
        currEmployerLabel.text = resultRoleModel.currEmployer
        
    }
}
