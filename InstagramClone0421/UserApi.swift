//
//  UserApi.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/26.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserApi {
    
    let REF_USERS = Database.database().reference().child("users")
    
    
    
    func observeUser(withId uid: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: { DataSnapshot in
            if let dict = DataSnapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict)
                completion(user)
            }
        })
    }

    
}
