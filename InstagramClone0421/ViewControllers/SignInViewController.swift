//
//  SignInViewController.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/21.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFIeld: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Api.User.CURRENT_USER != nil {
            performSegue(withIdentifier: "signInToTabber", sender: nil)
        }
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
        view.endEditing(true)
        ProgressHUD.show("wating...", interaction: false)
        
        AuthService.signIn(email: self.emailTextField.text!, password: self.passwordTextFIeld.text!, onSuccess: {
            ProgressHUD.showSuccess("ログインに成功しました")
            self.performSegue(withIdentifier: "signInToTabber", sender: nil)
            
        }) { (error) in
            ProgressHUD.showError(error!)
        }
    }
    
    

  

}
