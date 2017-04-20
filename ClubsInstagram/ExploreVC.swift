//
//  ExploreVC.swift
//  ClubsInstagram
//
//  Created by Kemuel Clyde Belderol on 21/04/2017.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase

class ExploreVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            
        }
    }
    var collectionviewLayout: CustomImageFlowLayout!
    var postIds : [String] = []
    var userUploadedPhotos = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionviewLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = collectionviewLayout
        collectionView.backgroundColor = .white
        filterPost()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func filterPost() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post(dictionary: dictionary)
                post.id = snapshot.key
                
                    let photoImageUrl = dictionary["postImageUrl"] as? String
                    
                    self.userUploadedPhotos.append(post)
                    
                    print("Id of postID", photoImageUrl ?? "lol")
                    
                    
                    
                    
                    DispatchQueue.main.async(execute: {
                        self.collectionView.reloadData()
                    })
                    
                
            }
            
        }, withCancel: nil)
    }

    
    

    
}

extension ExploreVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userUploadedPhotos.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCell", for: indexPath) as! ExpCollectionViewCell
        
        let post = userUploadedPhotos[indexPath.row]
        
        if let profileURL = post.postImageUrl {
            cell.imageView.loadImageUsingCacheWithUrlString(profileURL)
        }
        
        return cell
        
    }
}

