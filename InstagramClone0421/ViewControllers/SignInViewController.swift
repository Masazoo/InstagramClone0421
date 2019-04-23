//
//  SignInViewController.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/21.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFIeld: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        handleTextField()
    }
    
    func handleTextField() {
        
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        passwordTextFIeld.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextFIeld.text, !password.isEmpty else {
            signInBtn.setTitleColor(.white, for: .normal)
            signInBtn.isEnabled = false
            return
        }
        
        signInBtn.setTitleColor(.black, for: .normal)
        signInBtn.isEnabled = true
    }
    
    
    @IBAction func signInBtn_TouchUpInside(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextFIeld.text!) { (AuthDataResult, Error) in
            if Error != nil {
                print(Error!.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "signInToTabber", sender: nil)
        }
    }
    
    

  

}
