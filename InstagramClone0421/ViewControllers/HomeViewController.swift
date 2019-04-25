//
//  HomeViewController.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/21.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var posts = [Post]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.estimatedRowHeight = 521
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.dataSource = self
        loadPosts()
    }
    
    func loadPosts() {
        activityIndicator.startAnimating()
        Database.database().reference().child("posts").observe(.childAdded, with: { (DataSnapshot) in
            print(Thread.isMainThread)
            if let dict = DataSnapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict)
                self.fetchUser(uid: newPost.uid!, completed: {
                    self.posts.append(newPost)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.tableview.reloadData()
                })
                
            }
        })
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
        }
        )
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        return cell
    }
    
    
}
