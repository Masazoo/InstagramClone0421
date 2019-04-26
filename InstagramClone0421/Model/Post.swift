//
//  Post.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/24.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
class Post {
    
    var caption: String?
    var photoURL: String?
    var uid: String?
    var postId: String?
    
}
extension Post {
    
    static func transformPostPhoto(dict: [String: Any], key: String) -> Post{
        let post = Post()
        post.postId = key
        post.caption = dict["caption"] as? String
        post.photoURL = dict["photoURL"] as? String
        post.uid = dict["uid"] as? String
        return post
    }
}
