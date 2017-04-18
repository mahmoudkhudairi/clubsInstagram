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
    
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var currentUserID : String = ""
    
    var profileName : String? = ""
    var profileDesc : String? = ""
    var profileImage : String? = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IDPROFILE : ",currentUserID )
        
        
        listenToFirebase()
        
        
    }
    
    func setUpProfile() {
        
        nameLabel.text = profileName
        descLabel.text = profileDesc
        
        if let profileURL = profileImage {
        profileImageView.loadImageUsingCacheWithUrlString(profileURL)
        profileImageView.circlerImage()
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }

    
    func listenToFirebase() {
        
        FIRDatabase.database().reference().child("users").child(currentUserID).observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
            
            let dictionary = snapshot.value as? [String: Any]
            
            self.profileName = dictionary?["name"] as? String
            self.profileImage = dictionary? ["profileImageUrl"] as? String
            self.profileDesc = dictionary? ["desc"] as? String
            
            self.setUpProfile()
            
            
        })
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func followButtonClicked(_ sender: Any) {
        let uid = FIRAuth.auth()!.currentUser!.uid
       
        
        var isFollower = false
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as? String == self.currentUserID {
                        isFollower = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(self.currentUserID).child("followers/\(ke)").removeValue()
                        
                     self.followButton.setTitle("Follow", for: .normal)
                        
                    }
                }
            }
            if !isFollower {
                let following = ["following/\(self.currentUserID)" : true ]
                let followers = ["followers/\(uid)" : true]
                
                ref.child("users").child(uid).updateChildValues(following)
                ref.child("users").child(self.currentUserID).updateChildValues(followers)
                
                self.followButton.setTitle("Following!", for: .normal)
                
                
            }
        })
        ref.removeAllObservers()
        
       
    }
    
    
   

}
