//
//  LoginVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class LoginVC: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


    }

  
    
    
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                    
                self.goToFeedVC()
                
                }
            })
        }

    }

    @IBAction func SignUpButtonTapped(_ sender: Any) {
        let signupController = storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
            present(signupController!, animated: true, completion: nil)
        
        
    }
    
    func goToFeedVC() {
        let feedController = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        present(feedController!, animated: true, completion: nil)
        
    }
    

}
