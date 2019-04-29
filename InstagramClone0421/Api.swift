//
//  Api.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/26.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
struct Api {
    
    static var Post = PostApi()
    static var User = UserApi()
    static var Comment = CommentApi()
    static var PostComment = Post_CommentApi()
    static var MyPosts = MyPostsApi()
}
