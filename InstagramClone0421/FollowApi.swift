//
//  FollowApi.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/29.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase
class FollowApi {
    
    let REF_FOLLOWING = Database.database().reference().child("following")
    let REF_FOLLOWERS = Database.database().reference().child("followers")
    
    
    func isFollowing(uid: String, completed: @escaping (Bool) -> Void) {
        Api.follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(uid).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let _ = DataSnapshot.value as? NSNull {
                completed(false)
            }else{
                completed(true)
            }
        })
    }
}
