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
    
    func observePost(postId: String, completion: @escaping (Post) -> Void) {
        REF_POSTS.child(postId).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict, key: DataSnapshot.key)
                completion(newPost)
            }
        })
    }
    
    func observeLikeCount(postId: String, completion: @escaping (Int) -> Void) {
        Api.Post.REF_POSTS.child(postId).observe(.childChanged, with: { (DataSnapshot) in
            if let value = DataSnapshot.value as? Int {
                completion(value)
            }
        })
    }
    
    func observeTopPost(completion: @escaping (Post) -> Void) {
        Api.Post.REF_POSTS.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value, with: { (DataSnapshot) in
            let arraySnapshot = (DataSnapshot.children.allObjects as? [DataSnapshot])?.reversed()
            arraySnapshot?.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let newPost = Post.transformPostPhoto(dict: dict, key: DataSnapshot.key)
                    completion(newPost)
                }
            })
        })
    }
    
    func incrementsLikes(postId: String, onSuccess: @escaping (Post) -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        let postRef = Api.Post.REF_POSTS.child(postId)
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Api.User.CURRENT_USER?.uid {
                
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                
                var likeCount = post["likeCount"] as? Int ?? 0
                
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot!.key)
                onSuccess(post)
            }
        }
    }
    
}
