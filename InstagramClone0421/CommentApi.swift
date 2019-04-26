//
//  CommentApi.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/26.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
    
    var REF_COMMENTS = Database.database().reference().child("comments")
    
    func observeComments(commentId: String, completed: @escaping (Comment) -> Void) {
        REF_COMMENTS.child(commentId).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completed(newComment)
            }
        })
    }
    

    
    
}
