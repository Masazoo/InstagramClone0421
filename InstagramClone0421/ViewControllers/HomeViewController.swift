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
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
    }
    
    

    @IBAction func loguot_TouchUpInside(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let loguotError {
            print(loguotError)
        }
        dismiss(animated: true, completion: nil)
    }
    

}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.backgroundColor = .blue
        cell.textLabel?.text = "\(indexPath)"
        return cell
    }
    
    
}
