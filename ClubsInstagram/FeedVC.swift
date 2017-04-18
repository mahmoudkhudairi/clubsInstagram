//
//  FeedVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class FeedVC: UIViewController {
    var posts = [Post]()
    @IBOutlet weak var postsTableView: UITableView!{
         didSet{
         postsTableView.register(PostCell.cellNib, forCellReuseIdentifier: PostCell.cellIdentifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        fetchPost()
        
    }

      
    func fetchPost() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post(dictionary: dictionary)
                post.id = snapshot.key
               
                self.posts.append(post)
                
                
                DispatchQueue.main.async(execute: {
                    self.postsTableView.reloadData()
                })
                
            }
            
        }, withCancel: nil)
    }
    
    
    
    

   
}
extension FeedVC: UITableViewDelegate,UITableViewDataSource{
    
   

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.cellIdentifier, for: indexPath) as? PostCell else {  return UITableViewCell()}
        
        let post = posts[indexPath.row]
        
        cell.userNameLabel.text = post.userName
        if let userProfileImageUrl = post.userProfileImageUrl {
            cell.userProfileImageView.loadImageUsingCacheWithUrlString(userProfileImageUrl)
        }
        
        if let postImageUrl = post.postImageUrl {
            cell.postImage.loadImageUsingCacheWithUrlString(postImageUrl)
        }
        cell.captionTextView.text = post.caption
        cell.callTapGesture()
        cell.postIdentifier = post.id
        cell.observeLikesOnPost(post.id!)
        print("postid in CellforRow   ",post.id!)
        //3 conform
        cell.delegate = self
        //cell.updatepostLikesNumber(post.id!)
        return cell
    }
    internal func likeImageIstapped() -> Bool {
        return true
    }
    
    
}


extension FeedVC : PostCellDelegate {
    func likeImageTapped(withID: String, withNum: Int) {
        let numberOflike : [String:Any] = ["numberOfLikes":withNum]
        
//        print(numberOflike)
//        
////        FIRDatabase.database().reference().child("posts").child(withID).child("numberOfLikes").runTransactionBlock({(currentData: FIRMutableData!) in withNum = currentData.value as? Int
////            if (value == nil) {
////                value = 0
////            }
//        
//            print(currentData.value!)
//            return FIRTransactionResult.success(withValue: currentData)
//
//            
//        })
//        
    }
}
