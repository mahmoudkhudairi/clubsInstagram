//
//  ProfileVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase

enum ProfileType {
    case myProfile
    case otherProfile
}


class ProfileVC: UIViewController {

    var currentUserID = FIRAuth.auth()?.currentUser?.uid
    
    var profileType : ProfileType = .myProfile
    
    
    
    var ref : FIRDatabaseReference!
    var profileName : String? = ""
    var profileDesc : String? = ""
    var profileImage : String? = ""
    var numberOfPosts : Int? = 0
    var postIds : [String] = []
    var userUploadedPhotos = [Post]()
    @IBOutlet weak var followersnumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var postNumbersLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("IDPROFILE : ",currentUserID?  ?? "No user")
        ref = FIRDatabase.database().reference()
        
        
        configureForProfileType(profileType)
        
        listenToFirebase()
        getNumberofPosts()
        getNumberOfFollowers()
        getNumberOfFollowing()
        //fetchUsers()
        filterPost()
      // postCollectionView.delegate = self
        postCollectionView.dataSource = self
    }
    
    func configureForProfileType(_ type: ProfileType){
        switch type {
        case .myProfile:
            configureMyProfile()
        case .otherProfile:
            configureOtherProfile()
            
        }
    }
    
    func configureMyProfile(){
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped(_:)))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    func configureOtherProfile(){
        let barButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(logoutButtonTapped(_:)))
        navigationItem.leftBarButtonItem = barButtonItem
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
    
    func fetchUsers() {
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("post").observe(.childAdded, with: { (snapshot) in
            guard snapshot.exists() else { return }
            
            let allId = snapshot.key
            self.postIds.append(allId)
            print(allId)
            
            
            
            
            DispatchQueue.main.async(execute: {
                self.postCollectionView.reloadData()
            })
            
        }, withCancel: nil)
        
        
    }
    
    func filterPost() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post(dictionary: dictionary)
                post.id = snapshot.key
                let userId = dictionary["userId"] as? String
                
            if userId == FIRAuth.auth()?.currentUser?.uid {
                
                let photoImageUrl = dictionary["postImageUrl"] as? String
                
                self.userUploadedPhotos.append(post)
                
                print("Id of postID", photoImageUrl ?? "lol")
   
                
                
                
                DispatchQueue.main.async(execute: {
                    self.postCollectionView.reloadData()
                })
                
                }
            }
            
        }, withCancel: nil)
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
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
            
            let dictionary = snapshot.value as? [String: Any]
            
            self.profileName = dictionary?["name"] as? String
            self.profileImage = dictionary? ["profileImageUrl"] as? String
            self.profileDesc = dictionary? ["desc"] as? String
            
            self.setUpProfile()
            
            
        })
    
    }
    func getNumberofPosts(){
        FIRDatabase.database().reference().child("users").child(currentUserID!).child("posts").observe(.value, with: { (snapshot) in
            
          print(snapshot.childrenCount)
            self.postNumbersLabel.text = String("\(snapshot.childrenCount)\n Posts")
    
        })

    }
    
    func getNumberOfFollowing() {
        FIRDatabase.database().reference().child("users").child(currentUserID!).child("following").observe(.value, with: { (snapshot) in
            print(snapshot.childrenCount)
            self.followingNumberLabel.text = String("\(snapshot.childrenCount)\n Following")
        })
        
        
    }
    
    func getNumberOfFollowers() {
        FIRDatabase.database().reference().child("users").child(currentUserID!).child("followers").observe(.value, with: { (snapshot) in
            print(snapshot.childrenCount)
            self.followersnumberLabel.text = String("\(snapshot.childrenCount)\n Followers")
        })
        
        
    }

    
}
extension ProfileVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! CollectionViewCell
        
        let post = userUploadedPhotos[indexPath.row]
        
        if let profileURL = post.postImageUrl {
            cell.postImage.loadImageUsingCacheWithUrlString(profileURL)
        }

        return cell
       
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userUploadedPhotos.count
        
    }
    
}

