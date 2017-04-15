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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        let fireLogin = AuthController()
        
        fireLogin.login(email: email, password: password)
        
    }
    @IBAction func logInButtonTapped(_ sender: Any) {
        handleLogin()
        let Controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        present(Controller!, animated: true, completion: nil)

    }

    @IBAction func SignUpButtonTapped(_ sender: Any) {
        let Controller = storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
        present(Controller!, animated: true, completion: nil)
        
    }
    

}
