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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        
        loadPosts()
    }
    
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded, with: { (DataSnapshot) in
            print(Thread.isMainThread)
            if let dict = DataSnapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict)
                self.posts.append(newPost)
                self.tableview.reloadData()
            }
        })
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
        let cell = tableview.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.backgroundColor = .blue
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
    
}
