//
//  SignUpViewController.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/21.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var selectedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 50
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signUp_TouchUpInside(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextFiled.text!) { (AuthDataResult, Error) in
            if Error != nil {
                print(Error!.localizedDescription)
                return
            }
            
            let uid = AuthDataResult?.user.uid
            let storageRef = Storage.storage().reference(forURL: "gs://train-dbed9.appspot.com/").child("profile_image").child(uid!)
            if let profileImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.putData(imageData, metadata: nil, completion: { (StorageMetadata, Error) in
                    if Error != nil {
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (URL, Error) in
                        if Error != nil {
                            return
                        }
                        let profileImageURL = URL?.absoluteString
                        
                        let ref = Database.database().reference()
                        let usersRef = ref.child("users")
                        let newUserRef = usersRef.child(uid!)
                        newUserRef.setValue(["username": self.usernameTextField.text!, "email": self.emailTextField.text!, "profileImageURL": profileImageURL])
                    })
                })
            }
            
        }
    }
    
}
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
