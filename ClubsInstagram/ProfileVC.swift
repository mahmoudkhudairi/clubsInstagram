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

    var currentUserID = FIRAuth.auth()?.currentUser?.uid
    
  
    var ref : FIRDatabaseReference!
    var profileName : String = ""
    var profileDesc : String = ""
    var profileImage : String = ""

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IDPROFILE : ",currentUserID! )
        ref = FIRDatabase.database().reference()
        
        
        listenToFirebase()

       
    }
    
    func setUpProfile() {
        
        nameLabel.text = profileName
        descLabel.text = profileDesc
        
        let profileURL = profileImage
        profileImageView.loadImageUsingCacheWithUrlString(profileURL)
        profileImageView.circlerImage()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()

            guard let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC")else{return}
           
            ad.window?.rootViewController = loginController
          
    
        } catch let logoutError {
            print(logoutError)
        }
        
    
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        
        if let editController = storyboard?.instantiateViewController(withIdentifier: "EditVC") {
            present(editController, animated: true, completion: nil)
        }
        
        
    }
    
    func listenToFirebase() {
        ref.child("users").child(currentUserID!).observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
            
            let dictionary = snapshot.value as? [String: String]
            
            self.profileName = (dictionary? ["name"])!
            self.profileImage = (dictionary? ["profileImageUrl"])!
            self.profileDesc = (dictionary? ["desc"])!
            
            self.setUpProfile()
            
            
        })
    
    }

    



}
