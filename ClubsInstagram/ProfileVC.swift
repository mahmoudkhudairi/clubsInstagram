//
//  ProfileVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        guard let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC")else{return}
        
        present(loginController, animated: true, completion: nil)
    
    }



}
