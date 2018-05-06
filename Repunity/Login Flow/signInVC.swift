//
//  signInVC.swift
//  Repunity
//
//  Created by Erika Hairston on 4/24/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class signInVC: UIViewController, UITextFieldDelegate {

    //outlets
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmationPasswordText: UITextField!

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backSignIn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        confirmationPasswordText.isHidden = true
        backSignIn.isHidden = true
         self.passwordText.delegate = self
         self.confirmationPasswordText.delegate = self
    }

    //actions
    @IBAction func backToSignInClicked(_ sender: Any) {
        signUpButton.isHidden = false
        signInButton.setTitle("Sign In", for: .normal)
        backSignIn.isHidden = true
        self.viewDidLoad()
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        if signInButton.title(for: .normal) == "Sign In" {
            if emailText.text != "" && passwordText.text != "" {
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
                    if error != nil {
                        self.performErrorAlert(message: error?.localizedDescription)
                    } else {
                        UserDefaults.standard.set(user!.email, forKey: "user")
                        UserDefaults.standard.synchronize()
                        
                        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.rememberLogin()
                        //self.performSegue(withIdentifier: "toHomeTab", sender: nil)
                    }
                }
            } else {
                self.performErrorAlert(message: "Username and password needed")
            }
            
        } else {
            createAccount()
        }
    }
    

    @IBAction func signUpButtonClicked(_ sender: Any) {
        confirmationPasswordText.isHidden = false
        signUpButton.isHidden = true
        signInButton.setTitle("Sign Up", for: .normal)
        backSignIn.isHidden = false
    }
    //functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func performErrorAlert(message: String?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAccount() {
        if emailText.text != "" && passwordText.text != "" {
            if passwordText.text != confirmationPasswordText.text {
                 self.performErrorAlert(message: "Passwords do not match")
            } else {
                print("create user")
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
                    
                    if error != nil {
                        self.performErrorAlert(message: error?.localizedDescription)
                    } else {
                        
                        UserDefaults.standard.set(user!.email, forKey: "user")
                        UserDefaults.standard.synchronize()
                        print ("User Created \(self.emailText.text!))")
                        self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
                        
                       // let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                     //  delegate.rememberLogin()
                    }
                }
            }
        } else {
            self.performErrorAlert(message: "Username and password needed")
        }
    }
    
}
