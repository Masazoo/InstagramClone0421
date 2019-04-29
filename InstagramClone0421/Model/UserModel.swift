//
//  UserModel.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/24.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
class UserModel {
    
    var username: String?
    var email: String?
    var profileImageURL: String?
    var uid: String?
    var isFollowing: Bool?
    
}
extension UserModel {
    
    static func transformUser(dict: [String: Any], key: String) -> UserModel{
        let user = UserModel()
        user.username = dict["username"] as? String
        user.email = dict["email"] as? String
        user.profileImageURL = dict["profileImageURL"] as? String
        user.uid = key
        return user
    }
}
