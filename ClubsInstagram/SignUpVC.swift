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
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print("Error in signin: \(error)")
                return
            }
            
            
            guard let uid = user?.uid else {return}
            //save the user
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("\(imageName).jpeg")
            let image = self.pictureImageView.image
            guard let imageData = UIImageJPEGRepresentation(image!, 0.5) else { return }
            
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            storageRef.put(imageData, metadata: metaData, completion: { (metadata, error) in
                
                if error != nil {
                    print("Image error: \(error)")
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    let userName = user?.email
                    let values = ["email": userName, "name": name, "profileImageUrl": profileImageUrl]
                    self.registerUserIntoDataBase(uid, values: values)
                }
                
            })
            
              self.performSegue(withIdentifier: "toFeedVC", sender: nil)
            //self.goToFeedVC()
        })

    }
    
    private func registerUserIntoDataBase(_ uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference(fromURL: "https://clubsinstagram.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print("Error saving user: \(err)")
                return
            }
            
            
           // self.dismiss(animated: true, completion: nil)

        })
        
        
    }

    
//    func goToFeedVC() {
//        if let feedController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
//            present(feedController, animated: true, completion: nil)
//        }
//    }
    
    
}



