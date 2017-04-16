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

        // Do any additional setup after loading the view.
//        if FIRAuth.auth()?.currentUser != nil {
//            print("Some user is already logged in")
//            let goToFeed = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
//            present(goToFeed!, animated: true, completion: nil)
//            
//        }
    }

  
    
    
    
    @IBAction func logInButtonTapped(_ sender: Any) {
//        guard let email = emailTextField.text,
//            let password = passwordTextField.text else { return }
//        if email == "" || password == "" {
//            print("Can't be blank")
//        }
//        
//        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
//            
//            if let err = error {
//                print("Error signing in \(err.localizedDescription)")
//                return
//            }
//            
//            guard let user = user else {
//                print("User error")
//                return
//            }
//            
//            print("User: \(user) successfully logged-in")
//            self.goToFeedVC()
//            
//        })
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                    UserDefaults.standard.set(user!.email, forKey: "userinfo")
                    UserDefaults.standard.synchronize()
                

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
