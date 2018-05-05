//
//  part2SignUpVC.swift
//  Repunity
//
//  Created by Erika Hairston on 4/30/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class part2SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, ModalDelegate {
    
    
    //outlets
    @IBOutlet weak var collegeText: UITextField!
    @IBOutlet weak var gradYear: UITextField!
    @IBOutlet weak var primaryMajor: UITextField!
    @IBOutlet weak var currJobTitle: UITextField!
    @IBOutlet weak var currEmployer: UITextField!
    @IBOutlet weak var supportiveGroups: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var primaryIndustryText: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    
    //variables
    var ref: DatabaseReference! = Database.database().reference()
    //carried over from first part of Signup
    var firstName = ""
    var raceArray = [String]() //to use
    var raceSelection = ""
    var genderSelection = ""
    var isLGBTQSelection = false
    var isFirstGenSelection = false
    var funFact = ""
    var finalUrl = ""
    var selectedIndustry = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectImg()
        self.collegeText.delegate = self
        self.gradYear.delegate = self
        self.primaryMajor.delegate = self
        self.currJobTitle.delegate = self
        self.currEmployer.delegate = self
        self.supportiveGroups.delegate = self
        completeButton.isEnabled = false
        collegeText.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        gradYear.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        primaryMajor.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        currJobTitle.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
         currEmployer.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        supportiveGroups.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    func changeValue(value: String) {
        selectedIndustry = value
        primaryIndustryText.text = selectedIndustry
    }
    
    //actions
    @IBAction func pickIndustryClicked(_ sender: Any) {
        performSegue(withIdentifier: "toPresentModal", sender: nil)
    }
    
    @IBAction func completeButtonClicked(_ sender: Any) {
        uploadProfilePic(profileImage.image!) { (url) in
            if url != nil {
                print("Success: photo successfully added to storage")
                self.finalUrl = (url?.absoluteString)!
                print(self.finalUrl)
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User pic added!")
                        self.addAccountInfo(datURL: (url?.absoluteString)!)

                    } else {
                        print("Error: \(error!.localizedDescription)")
                    }
                }
            } else {
                print("Error: unable to upload pro pic")
                //self.performErrorAlert(message: "unable to upload pro pic")
            }
        }
        self.performSegue(withIdentifier: "signUpCompletetoHome", sender: nil)

      let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.rememberLogin()
    }
    
    //funcitons
    //hides keyboard when user presses return
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let collegeName = collegeText.text, !collegeName.isEmpty,
            let graduationYear = gradYear.text, !graduationYear.isEmpty,
            let primaryMajor = primaryMajor.text, !primaryMajor.isEmpty,
            let currJobTitle = currJobTitle.text, !currJobTitle.isEmpty,
            let currEmployer = currEmployer.text, !currEmployer.isEmpty,
            let supportiveGroups = supportiveGroups.text, !supportiveGroups.isEmpty
            else {
                completeButton.isEnabled = false
                return
        }
        completeButton.isEnabled = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        collegeText.resignFirstResponder()
        gradYear.resignFirstResponder()
        primaryMajor.resignFirstResponder()
        currJobTitle.resignFirstResponder()
        currEmployer.resignFirstResponder()
        supportiveGroups.resignFirstResponder()
        return true
    }
    
    func selectImg() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileImage.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(part2SignUpVC.choosePhoto))
        profileImage.addGestureRecognizer(recognizer)
    }
    
    @objc func choosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    

    //retrieve data from firebase
/*    func getDataFromServer() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        //.child("profile").child("user/\(uid)")
        Database.database().reference().child("users").observe(DataEventType.childAdded) { (snapshot) in
            snapshot //the data we will get
            
            let values = snapshot.value! as! NSDictionary
            print("TEST")
            let valIDs = values.allKeys
            for each in valIDs {
                 print("WASSUP!")
                print(uid)
                print(each)
                if each as! String == uid {
                    print(each)
                    let singlePic = values[each] as! NSDictionary
                    self.profileImageURL = singlePic["photoURL"] as! String
                    print("HIIIIII!")
                    print(self.profileImageURL)
                }
            }
            
        }
    }*/
    
    func uploadProfilePic(_ image:UIImage, completion: @escaping ((_ url: URL?) ->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        print("HERESHE IS")
        print(storageRef)
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                if let url = metaData?.downloadURL() {
                    completion(url)
                } else {
                    //self.performErrorAlert(message: error!.localizedDescription)
                    print("here")
                    completion(nil)
                }
                // success!
            } else {
                // failed
                //self.performErrorAlert(message: error!.localizedDescription)
                print(error!.localizedDescription)
                
                completion(nil)
            }
        }
    }
    
    
    func addAccountInfo(datURL: String) {
        //turning the rest of user info into a dictionary to upload
//        let account = []
//        let ids = []
//        let experience = []
//        let school = []
        print("ONE")
        print(self.finalUrl)
        
        print("TWO")
        print(datURL)
    
        
        let role_model = ["uuid" : (Auth.auth().currentUser?.uid)!, "name" : self.firstName, "email" : (Auth.auth().currentUser!.email!), "photoURL" : datURL, "race" : self.raceSelection, "gender" : self.genderSelection, "isLGBTQ" : self.isLGBTQSelection, "isFirstGen" : isFirstGenSelection, "underGrad" : collegeText.text!, "gradYear" : self.gradYear.text!, "primaryMajor" : self.primaryMajor.text!, "industry" : self.selectedIndustry, "currJobTitle" : currJobTitle.text!, "currEmployer" : currEmployer.text!, "supportGroups" : supportiveGroups!.text!, "funFact" : funFact] as [String : Any]
        
        self.ref.child("roleModels").child((Auth.auth().currentUser?.uid)!).setValue(role_model)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? industrySignUpViewController {
            destination.delegate = self
        }
    }

}
