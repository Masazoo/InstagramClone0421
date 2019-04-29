//
//  PeopleViewController.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/29.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var users = [UserModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.dataSource = self
        
        loadUsers()
    }
    

    func loadUsers() {
        Api.User.observeUsers { (user) in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }

}
extension PeopleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    
}
