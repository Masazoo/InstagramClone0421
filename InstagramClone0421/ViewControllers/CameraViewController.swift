//
//  CameraViewController.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/21.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

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
            HelperService.uploardDataToServer(imageData: imageData, caption: captionTextView.text!) {
                self.clean()
                self.tabBarController?.selectedIndex = 0
            }
        }else{
            ProgressHUD.showError("写真を選んでください")
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

