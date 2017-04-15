//
//  SignUpVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref: FIRDatabaseReference!
 
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleImage()
        
    }
    
    func handleImage(){
        
        pictureImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseProfileImage))
        pictureImageView.addGestureRecognizer(tap)
        
    }
    
    func chooseProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {return}
        
        if email == "" || password == "" || name == ""
        {
            print("Email or password is empty")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print("Error signup \(error)")
                return
            }
            
            guard let user = user
                else {
                    print("User does not exist")
                    return
            }

            
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("\(imageName).jpeg")
            let image = self.pictureImageView.image
            guard let imageData = UIImageJPEGRepresentation(image!, 0.4) else { return }
            
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            storageRef.put(imageData, metadata: metaData, completion: { (metadata, error) in
                
                if error != nil {
                    print("error saving image \(error)")
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                
                let values : [String : String] = ["email": user.email!, "name": user.displayName!, "imageUrl": profileImageUrl]
                
                self.ref.child("users").child("\(user.uid)").updateChildValues(values)
                }
        
            })
    
            self.goToFeedVC()
        }
 
    }
    
    func goToFeedVC() {
        if let feedController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            present(feedController, animated: true, completion: nil)
        }
    }
    
    
}



