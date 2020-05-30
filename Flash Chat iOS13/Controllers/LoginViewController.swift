//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
//    override func viewWillAppear(_ animated: Bool) {
//          super.viewWillAppear(true)
//          navigationController?.isNavigationBarHidden = false
//      }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        navigationController?.isNavigationBarHidden = false
//    }
    
    override func viewDidLoad() {
        passwordTextfield.delegate = self
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        login()
    }
    
    func login(){
        let email = emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let email = email, !email.isEmpty, let password = password, !password.isEmpty{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error{
                    print(error)
                }else{
                    self?.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }

}
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        login()
        return true
    }
}
