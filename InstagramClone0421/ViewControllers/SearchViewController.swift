//
//  SearchViewController.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/30.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var searchBar = UISearchBar()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "検索してみる？"
        searchBar.frame.size.width = view.frame.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
        doSearch()
    }
    

    func doSearch() {
        if let searchText = searchBar.text?.lowercased() {
            self.users.removeAll()
            self.tableView.reloadData()
            Api.User.queryUsers(text: searchText) { (user) in
                Api.follow.isFollowing(uid: user.uid!, completed: { (value) in
                    user.isFollowing = value
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
}
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
}
