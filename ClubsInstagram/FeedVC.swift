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
    //var uid = FIRAuth.auth()?.currentUser?.uid
    var posts = [Post]()
    var following = [String]()
    var postsUsersIds = [String]()
    @IBOutlet weak var postsTableView: UITableView!{
         didSet{
         postsTableView.register(PostCell.cellNib, forCellReuseIdentifier: PostCell.cellIdentifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        fetchUsers()
        fetchPost()
       
    }
    
  

    func fetchUsers() {
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("following").observe(.childAdded, with: { (snapshot) in
                guard snapshot.exists() else { return }
            
                let allId = (snapshot.value as? NSDictionary)?.allKeys as? [String] ?? []
                self.following.append(contentsOf: allId)
                print("FollowersUserIdsArray: ",self.following)
                
                DispatchQueue.main.async(execute: {
                    self.postsTableView.reloadData()
                })
                
            
       // }
        }, withCancel: nil)
    }
    
    func fetchPost() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post(dictionary: dictionary)
                post.id = snapshot.key
               
                self.posts.append(post)
                self.postsUsersIds.append(post.userId!)
                print("postUserIdsArray: ",self.postsUsersIds)
                
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
        cell.checkLiked(postID: post.id!, indexpath:indexPath)
       
      
        
//        cell.observeLikesOnPost(post.id!)
//
        
        //3 conform
        cell.delegate = self
        //cell.updatepostLikesNumber(post.id!)
        return cell
    }
    internal func likeImageIstapped() -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.postsTableView.deselectRow(at: indexPath, animated: true)
    }
}


extension FeedVC : PostCellDelegate {
    func likeImageTapped(withID: String) {
      //  let numberOflike : [String:Any] = ["numberOfLikes":withNum]
      //  FIRDatabase.database().reference().child("posts").child(withID).updateChildValues(numberOflike)
        
print("hi from delegate Feed")
    }
}
