//
//  SecondViewController.swift
//  Repunity
//
//  Created by Erika Hairston on 4/24/18.
//  Copyright © 2018 Erika Hairston. All rights reserved.
//

import UIKit

class discoverVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //vars
    let ids : [String] = ["Black", "Latinx", "Native", "Asian", "Women", "Men", "Non-Binary", "Trans*", "LGBTQ", "firstGen"]
    let industries :  [String] = ["Tech", "Government", "Art", "Education"]
    let catNames : [String] = ["Black in Tech", "Latinx in Art", "Women in Politics", "LGBTQ in Tech", "firstGen in Art", "Non-Binary in Tech"]
    var chosenCat = ""
    
    
    //outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    
    //actions
    
    //functions
    
    //setup number of collection views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return catNames.count
    }
    
    @objc func catPressed(sender:UIButton) {
        
        chosenCat = catNames[sender.tag]
        performSegue(withIdentifier: "toDiscoverResults", sender: nil)
        
    }

    
    //populate the collection cell views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catCell", for: indexPath) as! catCell
        
        cell.catButton.setTitle(catNames[indexPath.row], for: .normal)
        cell.catButton.tag = indexPath.row
        cell.catButton.addTarget(self, action: #selector(catPressed), for: .touchUpInside)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDiscoverResults" {
            let catResultsVC = segue.destination as! resultsVC
            catResultsVC.category = chosenCat
            
        }
    }
    
    
}

