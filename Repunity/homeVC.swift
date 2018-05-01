//
//  FirstViewController.swift
//  Repunity
//
//  Created by Erika Hairston on 4/24/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit

class homeVC: UIViewController {
    
    //variables
    
    //outlests
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currJobLabel: UILabel!
    @IBOutlet weak var employerLabel: UILabel!
    
    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var spotLightImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //actions
    @IBAction func blackCategoryClicked(_ sender: Any) {
        performSegue(withIdentifier: "toResults", sender: nil)
    }
    
    //functions

}

