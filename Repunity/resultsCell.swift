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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //actions
    
    //functions

}
