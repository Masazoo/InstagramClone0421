//
//  AuthService.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/23.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class AuthService {
    
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error?.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (AuthDataResult, Error) in
            if Error != nil {
                onError(Error!.localizedDescription)
                return
            }
            
            let uid = AuthDataResult?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)

                storageRef.putData(imageData, metadata: nil, completion: { (StorageMetadata, Error) in
                    if Error != nil {
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (URL, Error) in
                        if Error != nil {
                            return
                        }
                        let profileImageURL = URL?.absoluteString
                        
                        setUserInfomation(username: username, email: email, profileImageURL: profileImageURL!, uid: uid!, onSuccess: onSuccess)
                    })
                })
        }
    }
    
    static func setUserInfomation(username: String, email: String, profileImageURL: String, uid: String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users")
        let newUserRef = usersRef.child(uid)
        newUserRef.setValue(["username": username, "email": email, "profileImageURL": profileImageURL])
        onSuccess()
        
    }
}
