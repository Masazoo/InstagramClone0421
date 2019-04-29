//
//  HelperService.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/27.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
class HelperService {
    
    static func uploardDataToServer(imageData: Data, caption: String, onSuccess: @escaping () -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
        storageRef.putData(imageData, metadata: nil, completion: { (StorageMetadata, Error) in
            if Error != nil {
                return
            }
            storageRef.downloadURL(completion: { (URL, Error) in
                if Error != nil {
                    return
                }
                let photoURL = URL?.absoluteString
                sendDataToDatabase(photoURL: photoURL!, caption: caption, onSuccess: onSuccess)
            })
        })
    }
    
    static func sendDataToDatabase(photoURL: String, caption: String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let postsRef = ref.child("posts")
        let newPostsId = postsRef.childByAutoId().key
        let newPostsrRef = postsRef.child(newPostsId!)
        let uid = Api.User.CURRENT_USER?.uid
        newPostsrRef.setValue(["photoURL": photoURL, "caption": caption, "uid": uid!, "likeCount": 0]) { (Error, ref) in
            if Error != nil {
                ProgressHUD.showError(Error?.localizedDescription)
            }
            
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(uid!).child(newPostsId!)
            myPostRef.setValue(true) { (Error, DatabaseReference) in
                if Error != nil {
                    ProgressHUD.showError(Error?.localizedDescription)
                }
            }
            ProgressHUD.showSuccess("投稿が成功しました")
            onSuccess()
        }
    }
}
