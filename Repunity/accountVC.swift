//
//  accountVC.swift
//  Repunity
//
//  Created by Erika Hairston on 4/24/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit

class accountVC: UIViewController {
    
    //variables
    
    //outlets
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var logInSignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user : String? = UserDefaults.standard.string(forKey: "user")
        if user == nil {
            logOutButton.isHidden = true
            logInSignUpButton.isHidden = false
        } else {
            logOutButton.isHidden = false
            logInSignUpButton.isHidden = true
        }

        // Do any additional setup after loading the view.
    }
    
    //actions
    @IBAction func logoutClicked(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
        
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC 
        
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = signIn
        
        delegate.rememberLogin()
    }
    
    @IBAction func logInorSignUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "accountToLogIn", sender: nil)
    }
    
    //functions


}
