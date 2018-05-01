//
//  resultsVC.swift
//  Repunity
//
//  Created by Erika Hairston on 4/25/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit

class resultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    //variables
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    //functions
    
    //setup tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    //define cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! resultsCell
        //let cell = UITableViewCell()
        // set values
        // cell.postText.text = postCommentArray[indexPath.row]
        //cell.userNameLabel.text = userEmailArray[indexPath.row]
        //cell.postImage.sd_setImage(with: URL(string: self.postImageURLArray[indexPath.row]))
        
        return cell
    }
    
    //actions
    

}
