//
//  CameraViewController.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/21.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost() {
        if selectedImage != nil {
            shareBtn.isEnabled = true
            shareBtn.backgroundColor = .black
        }else{
            shareBtn.isEnabled = false
            shareBtn.backgroundColor = .lightGray
        }
    }

    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func removeBtn_TouchUpInside(_ sender: Any) {
        self.clean()
        self.handlePost()
    }
    
    
    @IBAction func shareBtn_TouchUpInside(_ sender: Any) {
        view.endEditing(false)
        ProgressHUD.show("wating...", interaction: true)
        if let photoImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(photoImage, 0.1) {
                let photoIdString = NSUUID().uuidString
                let storageRef = Storage.storage().reference(forURL: "gs://train-dbed9.appspot.com/").child("posts").child(photoIdString)
                storageRef.putData(imageData, metadata: nil, completion: { (StorageMetadata, Error) in
                    if Error != nil {
                        return
                    }
                    storageRef.downloadURL(completion: { (URL, Error) in
                        if Error != nil {
                            return
                        }
                        let photoURL = URL?.absoluteString
                        self.sendDataToDatabase(photoURL: photoURL!)
                    })
                })
        }else{
            ProgressHUD.showError("写真を選んでください")
        }
    }
    
    func sendDataToDatabase(photoURL: String) {
        let ref = Database.database().reference()
        let postsRef = ref.child("posts")
        let newPostsId = postsRef.childByAutoId().key
        let newPostsrRef = postsRef.child(newPostsId!)
        newPostsrRef.setValue(["photoURL": photoURL, "caption": captionTextView.text!]) { (Error, DatabaseReference) in
            if Error != nil {
                ProgressHUD.showError(Error?.localizedDescription)
            }
            ProgressHUD.showSuccess("投稿が成功しました")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func clean() {
        self.photo.image = UIImage(named: "Placeholder-image")
        self.captionTextView.text = ""
        self.selectedImage = nil
    }
    
}
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

