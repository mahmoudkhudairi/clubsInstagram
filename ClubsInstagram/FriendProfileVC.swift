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
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userPostCollectionView: UICollectionView! {
        didSet{
            userPostCollectionView.delegate = self
            userPostCollectionView.dataSource = self
            
        }
    }
    var collectionviewLayout: CustomImageFlowLayout!
    
    var currentUserID : String = ""
    var postIds : [String] = []
    var userUploadedPhotos = [Post]()
    var profileName : String? = ""
    var profileDesc : String? = ""
    var profileImage : String? = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFollowed()
       
        
        followButton.addTarget(self, action: #selector(followButtonClicked), for: .touchUpInside)
        listenToFirebase()
        getNumberOfFollowing()
        getNumberOfFollowers()
        getNumberofPosts()
        
        collectionviewLayout = CustomImageFlowLayout()
        userPostCollectionView.collectionViewLayout = collectionviewLayout
        userPostCollectionView.backgroundColor = .white

        
        filterPost()
       
        
        
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
    
    func filterPost() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post(dictionary: dictionary)
                post.id = snapshot.key
                let userId = dictionary["userId"] as? String
                
                if userId == self.currentUserID {
                    
                    let photoImageUrl = dictionary["postImageUrl"] as? String
                    
                    self.userUploadedPhotos.append(post)
                    
                    print("Id of postID", photoImageUrl ?? "lol")
                    
                    DispatchQueue.main.async(execute: {
                        self.userPostCollectionView.reloadData()
                    })
                    
                }
            }
            
        }, withCancel: nil)
    }
    
   
    
    func checkFollowed() {
        let uid = FIRAuth.auth()!.currentUser!.uid
        var isFollower = false
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, _) in following {
                    if ke  == self.currentUserID {
                        isFollower = true
                        
                        self.followButton.setTitle("Following", for: .normal)
                        
                    }
                }
            }
            if !isFollower {
               
                
                self.followButton.setTitle("Follow", for: .normal)
                
                
            }
        })
        ref.removeAllObservers()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
     func followButtonClicked() {
        let uid = FIRAuth.auth()!.currentUser!.uid
       
        
        var isFollower = false
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, _) in following {
                    if ke  == self.currentUserID {
                        isFollower = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(self.currentUserID).child("followers/\(uid)").removeValue()
                        
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
    
    func getNumberofPosts(){
        FIRDatabase.database().reference().child("users").child(currentUserID).child("posts").observe(.value, with: { (snapshot) in
            
            print(snapshot.childrenCount)
            self.postLabel.text = String("\(snapshot.childrenCount)\n Posts")
            
        })
        
    }
    
    func getNumberOfFollowing() {
        FIRDatabase.database().reference().child("users").child(currentUserID).child("following").observe(.value, with: { (snapshot) in
            print(snapshot.childrenCount)
            self.followingLabel.text = String("\(snapshot.childrenCount)\n Following")
        })
        
        
    }
    
    func getNumberOfFollowers() {
        FIRDatabase.database().reference().child("users").child(currentUserID).child("followers").observe(.value, with: { (snapshot) in
            print(snapshot.childrenCount)
            self.followerLabel.text = String("\(snapshot.childrenCount)\n Followers")
        })
        
        
    }

}

extension FriendProfileVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userPostCollectionView.dequeueReusableCell(withReuseIdentifier: "userPostCell", for: indexPath) as! UserCollectionViewCell
        
        let post = userUploadedPhotos[indexPath.row]
        
        if let profileURL = post.postImageUrl {
            cell.imageView.loadImageUsingCacheWithUrlString(profileURL)
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userUploadedPhotos.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
}

