//
//  LoginAuth.swift
//  FunChat
//
//  Created by Arkadijs Makarenko on 10/04/2017.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthController{
    func login(email: String, password:String){
        //import FirebaseAuth
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let err = error{
                print("SingIn Error: \(err.localizedDescription)")
                return
            }
            guard let user = user else {
                print("User Error ")
                return
            }
            print("user logged in")
            print("email : \(user.email)")
            print("uid : \(user.uid)")
            
            //go to your main page
            
            
        }
    }
    func logout(){
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
           
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func singup(email:String, password:String){
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let err = error{
                print("Sign Up Error: \(err.localizedDescription)")
                return
            }
            guard let user = user
                else{
                    print("User not found")
                    return
            }
            print("User Created")
            print("Email: \(user.email)")
            print("uid: \(user.uid)")
            
            self.login(email: email, password: password)
            
        }
    }
}
