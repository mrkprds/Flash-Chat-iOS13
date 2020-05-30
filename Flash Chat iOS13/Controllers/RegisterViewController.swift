//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import  FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
        
    @IBAction func registerPressed(_ sender: UIButton) {
        let email = emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let email = email, !email.isEmpty, let password = password, !password.isEmpty{
            print("hello")
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error{
                    print(error)
                }else{
                 //open chatvc
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
}
