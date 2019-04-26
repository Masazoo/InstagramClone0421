//
//  PostApi.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/26.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase
class PostApi {
    
    let REF_POSTS = Database.database().reference().child("posts")
    
    
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict, key: DataSnapshot.key)
                completion(newPost)
            }
        })
    }
    
    
    
}
