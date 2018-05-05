//
//  industrySignUpViewController.swift
//  Repunity
//
//  Created by Erika Hairston on 5/4/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit

protocol ModalDelegate {
    func changeValue(value: String)
}


class industrySignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    
    //variables
    var industryNames = [String]()
    var delegate: ModalDelegate?
    var selectedIndustry: String = ""

    
    //outlets
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        industryNames = ["Architecture", "Communitications", "Consulting", "Education", "Energy", "Entertainment", "Environment", "Finance", "Fine Arts", "Government", "Healthcare", "Law" ,"Publishing/Media", "Religious Instituion",  "Retail", "Social Work", "Technology", "Executive"]
        
        popUpView!.layer.cornerRadius = 10
        popUpView!.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    //table view setup
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndustry = industryNames[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = industryNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return industryNames.count
    }

    @IBAction func closeIndustryPopUp(_ sender: Any) {
        self.delegate?.changeValue(value : self.selectedIndustry)
        dismiss(animated: true, completion: nil)
    }
}
