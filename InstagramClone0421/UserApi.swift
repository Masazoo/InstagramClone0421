//
//  UserApi.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/26.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    
    let REF_USERS = Database.database().reference().child("users")
    
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        
        return REF_USERS.child(currentUser.uid)
    }
    
    
    
    
    func observeUser(withId uid: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: { DataSnapshot in
            if let dict = DataSnapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict, key: DataSnapshot.key)
                completion(user)
            }
        })
    }
    
    func observeCurrentUser(completion: @escaping (UserModel) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        Api.User.observeUser(withId: currentUser.uid) { (user) in
            completion(user)
        }
    }
    
    func observeUsers(completion: @escaping (UserModel) -> Void) {
        REF_USERS.observe(.childAdded, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict, key: DataSnapshot.key)
                completion(user)
            }
        })
    }
    
    func queryUsers(text: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            DataSnapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String: Any] {
                    let user = UserModel.transformUser(dict: dict, key: child.key)
                    completion(user)
                }
            })
        })
    }
    

    
    
    
}
