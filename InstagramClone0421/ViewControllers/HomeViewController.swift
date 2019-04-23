//
//  HomeViewController.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/21.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func loguot_TouchUpInside(_ sender: Any) {
        print(Auth.auth().currentUser!)
        do {
            try Auth.auth().signOut()
        } catch let loguotError {
            print(loguotError)
        }
        print(Auth.auth().currentUser ?? "nil")
        dismiss(animated: true, completion: nil)
    }
    

}
