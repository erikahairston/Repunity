//
//  catCell.swift
//  Repunity
//
//  Created by Erika Hairston on 4/26/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit

//var

//outlets

class catCell: UICollectionViewCell {
    
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var catCellView: UILabel!
   
    @IBAction func catButtonPressed(_ sender: Any) {
        
        print("success")
    }
}