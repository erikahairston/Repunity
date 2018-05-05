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
    @IBOutlet weak var currIndustry: UILabel!
    @IBOutlet weak var inCommonText: UILabel!
    
    func setTopValues(resultRoleModel: RoleModel){
        nameLabel.text = resultRoleModel.name
        ImageService.getImage(withURL: resultRoleModel.imgURL) { (image) in
            self.myTopImageView.image = image
        }
       //myTopImageView.layer.cornerRadius = myTopImageView.bounds.height / 4
         //myTopImageView.layer.masksToBounds = true
        //imgContainerView!.layer.cornerRadius = 10
        //imgContainerView!.layer.masksToBounds = true

        currIndustry.text = resultRoleModel.industry
        
        //currEmployerLabel.text = resultRoleModel.currEmployer
        
    }
}
