//
//  FriendProfileVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/17/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase


class FriendProfileVC: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var currentUserID : String = ""
    
    var ref : FIRDatabaseReference!
    var profileName : String = ""
    var profileDesc : String = ""
    var profileImage : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IDPROFILE : ",currentUserID )
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
    
    

    
    func listenToFirebase() {
        ref.child("users").child(currentUserID).observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
            
            let dictionary = snapshot.value as? [String: String]
            
            self.profileName = (dictionary? ["name"])!
            self.profileImage = (dictionary? ["profileImageUrl"])!
            self.profileDesc = (dictionary? ["desc"])!
            
            self.setUpProfile()
            
            
        })
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var followButtonPressed: UIButton!
    
    
   

}
