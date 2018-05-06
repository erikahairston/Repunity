//
//  AboutModalVC.swift
//  Repunity
//
//  Created by Erika Hairston on 5/5/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit

class AboutModalVC: UIViewController {
    
    //variables    
    
    //outlets
    @IBOutlet weak var bottomAbout: UIView!
    @IBOutlet weak var topAbout: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomAbout.layer.cornerRadius = 3
        bottomAbout.layer.masksToBounds = true
        topAbout.layer.cornerRadius = 10
        topAbout.layer.masksToBounds = true
    }

    @IBAction func closePopUpClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

