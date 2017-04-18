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
    var following = [String]()
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
        let ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let users = snapshot.value as? [String : AnyObject] else { return }
            for(_,value) in users {
                if let uid = value["id"] as? String {
                    if uid == FIRAuth.auth()?.currentUser?.uid {
                        if let followingUsers = value["following"] as? [String : String] {
                            for(_,user) in followingUsers {
                                self.following.append(user)
                            }
                        }
                        self.following.append((FIRAuth.auth()?.currentUser?.uid)!)
                        
                        ref.child("post").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                            
                            let postSnap = snap.value as! [String : AnyObject]
                            
                            for(_,post) in postSnap {
                                if let userID = post["userId"] as? String {
                                    for each in self.following {
                                        if each == userID {
                                            let posst = Post(dictionary: postSnap)
                                            if let authorOfPost = post["userName"] as? String, let likes = post["numberOfLikes"] as? Int, let postImage = post["postImageUrl"] as? String, let postId = post["id"] as? String {
                                                
                                                posst.userName = authorOfPost
                                                posst.numberOfLikes = likes
                                                posst.postImageUrl = postImage
                                                posst.id = postId
                                                posst.userId = userID
                                                
                                                self.posts.append(posst)
                                                
                                            }
                                        }
                                        
                                    }

                                    self.postsTableView.reloadData()

                                }
                            }
                            
                        })
                    }
                }
            }
            
        })
        
        ref.removeAllObservers()
        
        
    }

      
//    func fetchPost() {
//        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
//            
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let post = Post(dictionary: dictionary)
//                post.id = snapshot.key
//               
//                self.posts.append(post)
//                
//                
//                DispatchQueue.main.async(execute: {
//                    self.postsTableView.reloadData()
//                })
//                
//            }
//            
//        }, withCancel: nil)
//    }
   
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
        //cell.callTapGesture()
        cell.postIdentifier = post.id
        //cell.numberOflikes = post.numberOfLikes
        
//        cell.observeLikesOnPost(post.id!)
//        print("postid in CellforRow   ",post.id!)
        
        //3 conform
        //cell.delegate = self
        //cell.updatepostLikesNumber(post.id!)
        return cell
    }
    internal func likeImageIstapped() -> Bool {
        return true
    }
    
    
}

//
//extension FeedVC : PostCellDelegate {
//    func likeImageTapped(withID: String, withNum: Int) {
//        let numberOflike : [String:Any] = ["numberOfLikes":withNum]
//        FIRDatabase.database().reference().child("posts").child(withID).updateChildValues(numberOflike)
//        
//    }
//}
