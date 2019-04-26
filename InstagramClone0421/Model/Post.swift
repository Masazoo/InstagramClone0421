//
//  Post.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/24.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseAuth
class Post {
    
    var caption: String?
    var photoURL: String?
    var uid: String?
    var postId: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    
}
extension Post {
    
    static func transformPostPhoto(dict: [String: Any], key: String) -> Post{
        let post = Post()
        post.postId = key
        post.caption = dict["caption"] as? String
        post.photoURL = dict["photoURL"] as? String
        post.uid = dict["uid"] as? String
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        if let currentUserId = Auth.auth().currentUser?.uid {
            if post.likes != nil {
                post.isLiked = post.likes![currentUserId] != nil
            }
        }
        
        return post
    }
}
