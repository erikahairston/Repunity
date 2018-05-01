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
    let catNames : [String] = ["Black in Tech", "Latinx in Art", "Women in Politics" ]
    
    
    //outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
       
    }
    
    //setup number of collection views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return catNames.count
    }
    
    //populate the collection cell views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catCell", for: indexPath) as! catCell
        
        cell.catButton.setTitle(catNames[indexPath.row], for: .normal)
        
        return cell
    }


}

