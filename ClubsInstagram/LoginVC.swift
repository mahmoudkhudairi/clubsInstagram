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
        if FIRAuth.auth()?.currentUser != nil {
            print("Some user is already logged in")
            if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            present(tabBarController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        if email == "" || password == "" {
            print("Can't be blank")
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let err = error {
                print("Error signing in \(err.localizedDescription)")
                return
            }
            
            guard let user = user else {
                print("User error")
                return
            }
            
            print("User: \(user) successfully logged-in")
            self.goToFeedVC()
            
        })
       

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
