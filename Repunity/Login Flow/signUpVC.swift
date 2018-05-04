//
//  signUpVC.swift
//  Repunity
//
//  Created by Erika Hairston on 4/24/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class signUpVC: UIViewController, UITextFieldDelegate {
    
    //variables
    var ref: DatabaseReference! = Database.database().reference()
    var raceArray = [String]() //to use
    var raceSelection = ""
    var genderSelection = ""
    var isLGBTQSelection = false
    var isFirstGenSelection = false
    
    //outlests
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var genderTextLabel: UILabel!
    @IBOutlet weak var genderSeg: UISegmentedControl!
    @IBOutlet weak var raceTextLabel: UILabel!
    @IBOutlet weak var raceSeg: UISegmentedControl!
    @IBOutlet weak var isLGBTQSeg: UISegmentedControl!
    @IBOutlet weak var isFirstGenSeg: UISegmentedControl!
    @IBOutlet weak var funFactText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameText.delegate = self
        self.funFactText.delegate = self
       
    }
    
    //actions
    @IBAction func genderIndxChanged(_ sender: Any) {
        
    }
    
    @IBAction func raceIndxChanged(_ sender: Any) {
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        mapGenderIndx()
        mapRaceIndex()
        isLGBTQ()
        isFirstGen()
        self.performSegue(withIdentifier: "toContinueSignUp", sender: nil)
    }
    
    
    //functions
    
    //hides keyboard when user presses return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameText.resignFirstResponder()
        funFactText.resignFirstResponder()
        return true
    }
    
    func mapGenderIndx() {
        switch genderSeg.selectedSegmentIndex
        {
            case 0:
                genderSelection = "Man";
            case 1:
                genderSelection = "Woman";
            case 2:
                genderSelection = "Non-binary";
            case 3:
                genderSelection = "Trans*";
            default:
                genderSelection = "Man";
        }
    }
    
    func mapRaceIndex() {
        switch raceSeg.selectedSegmentIndex
        {
        case 0:
            self.raceSelection = "Black";
        case 1:
            self.raceSelection = "White";
        case 2:
            self.raceSelection = "Latinx";
        case 3:
            self.raceSelection = "Asian";
        case 4:
            self.raceSelection = "Native";
        default:
            self.raceSelection = "Black";
        }
    }
    
    func isLGBTQ() {
        switch isLGBTQSeg.selectedSegmentIndex
        {
        case 0:
            isLGBTQSelection = false
        case 1:
            isLGBTQSelection = true;
        default:
            isLGBTQSelection = false;
        }
    }
    
    func isFirstGen() {
        switch isFirstGenSeg.selectedSegmentIndex
        {
        case 0:
            isFirstGenSelection = false
        case 1:
            isFirstGenSelection = true;
        default:
            isFirstGenSelection = false;
        }
    }
    
    
    func performErrorAlert(message: String?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
/*    func handleSignUp() {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in

                if error != nil {
                    self.performErrorAlert(message: error?.localizedDescription)
                } else {

                    //turning the rest of user info into a dictionary to upload
                    let role_model = ["name" : self.firstNameText.text!, "email" : (Auth.auth().currentUser!.email!), "race" : self.raceSelection, "gender" : self.genderSelection, "sector" : self.sectorSelection] as [String : Any]

                    self.ref.child("roleModels").child((Auth.auth().currentUser?.uid)!).setValue(role_model)


                    UserDefaults.standard.set(user!.email, forKey: "user")
                    UserDefaults.standard.synchronize()

                   let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                   delegate.rememberLogin()
                }
            }
        } else {
            self.performErrorAlert(message: "Username and password needed")
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let continueCreateAccountVC = segue.destination as! part2SignUpVC
        continueCreateAccountVC.firstName = firstNameText.text!
        continueCreateAccountVC.raceSelection = raceSelection
        continueCreateAccountVC.genderSelection = genderSelection
        continueCreateAccountVC.isLGBTQSelection = isLGBTQSelection
        continueCreateAccountVC.isFirstGenSelection = isFirstGenSelection
        continueCreateAccountVC.funFact = funFactText.text!
    }
    
    
}
